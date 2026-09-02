---Persistent oxfmt LSP client for vite-plus projects.
---
---Why this exists: `vp fmt` and the vite-plus `oxfmt` stdin wrapper re-evaluate
---`vite.config.ts` (the `fmt` block) on *every* invocation, costing ~1.2s per
---format. That makes format-on-save painfully slow. oxfmt's `--lsp` mode loads
---the config **once** and caches it, so the first format pays the warm-up
---(~0.5-1s, in the background) and every format after is ~0.3ms.
---
---This module owns a long-lived oxfmt LSP client per project root and exposes a
---conform-compatible Lua formatter (`format`) plus an eager warm-up entry
---(`ensure`) to call when a supported file opens.
local M = {}

local vp = require("util.vite_plus")

---Roots whose oxfmt config has already been warmed (so we don't fire redundant
---warm-up requests for every opened file).
---@type table<string, boolean>
local warmed = {}

---Find the running oxfmt LSP client for a project root, if any.
---@param root string
---@return vim.lsp.Client|nil
local function get_client(root)
  for _, c in ipairs(vim.lsp.get_clients({ name = "oxfmt" })) do
    if c.config.root_dir == root then
      return c
    end
  end
  return nil
end

---Start the oxfmt LSP client for `root`, attached to `buf`.
---@param root string
---@param buf integer
---@return vim.lsp.Client|nil
local function start_client(root, buf)
  local cmd = vp.oxfmt_command(root)
  if not cmd then
    return nil
  end
  local id = vim.lsp.start({
    name = "oxfmt",
    cmd = { cmd, "--lsp" },
    root_dir = root,
    filetypes = vp.supported_filetypes,
    on_exit = function()
      warmed[root] = nil
    end,
  }, {
    bufnr = buf,
    reuse_client = function(client, config)
      return client.name == config.name and client.config.root_dir == config.root_dir
    end,
  })
  return id and vim.lsp.get_client_by_id(id) or nil
end

---Get (or start+attach) the oxfmt client for `buf`'s vite-plus project root.
---Returns nil for non-vite-plus projects or buffers without a file path.
---@param buf integer
---@return vim.lsp.Client|nil client
---@return string|nil root
local function client_for(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return nil, nil
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return nil, nil
  end
  local root = vp.find_root(name)
  if not root then
    return nil, nil
  end
  local client = get_client(root)
  if client then
    if not vim.lsp.buf_is_attached(buf, client.id) then
      vim.lsp.buf_attach_client(buf, client.id)
    end
    return client, root
  end
  client = start_client(root, buf)
  return client, root
end

---Apply LSP `TextEdit[]` to a list of lines, returning the new lines.
---Uses nvim's battle-tested `vim.lsp.util.apply_text_edits` on a throwaway
---buffer (with the client's offset encoding) so multi-edit / partial-range
---results are handled correctly. oxfmt typically returns several small edits
---(e.g. `"bar"` -> `'bar'`, drop `;`), not one whole-document replacement.
---@param lines string[]
---@param edits table[]|nil
---@param offset_encoding string
---@return string[]
local function apply_edits(lines, edits, offset_encoding)
  if not edits or #edits == 0 then
    return lines
  end
  local tmp = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(tmp, 0, -1, false, lines)
  vim.lsp.util.apply_text_edits(edits, tmp, offset_encoding)
  local out = vim.api.nvim_buf_get_lines(tmp, 0, -1, false)
  vim.api.nvim_buf_delete(tmp, { force = true })
  return out
end

---Invoke `callback` once `client` has finished the LSP initialize handshake.
---conform's Lua formatter is callback-driven, so it's fine to wait here.
---@param client vim.lsp.Client
---@param callback fun()
local function when_ready(client, callback)
  if client.initialized then
    return callback()
  end
  local timer = vim.uv.new_timer()
  local n = 0
  timer:start(15, 15, vim.schedule_wrap(function()
    n = n + 1
    if client.initialized or n > 200 then -- ~3s
      timer:stop()
      if not timer:is_closing() then
        timer:close()
      end
      callback()
    end
  end))
end

---conform-compatible Lua formatter entry point.
---@param ctx table conform context: { buf, filename, dirname, range, shiftwidth }
---@param lines string[] current buffer lines
---@param callback fun(err: string|nil, lines: string[]|nil)
function M.format(ctx, lines, callback)
  local buf = ctx.buf
  local client = client_for(buf)
  if not client then
    return callback("oxfmt: not a vite-plus project (or no file path)", nil)
  end

  local function request()
    local params = {
      textDocument = { uri = vim.uri_from_bufnr(buf) },
      options = {
        tabSize = ctx.shiftwidth or vim.bo[buf].shiftwidth or 2,
        insertSpaces = vim.bo[buf].expandtab ~= false,
      },
    }
    local offset_encoding = client.offset_encoding or "utf-16"
    client:request("textDocument/formatting", params, function(err, result)
      if err then
        return callback(tostring(err.message or err), nil)
      end
      callback(nil, apply_edits(lines, result or {}, offset_encoding))
    end, buf)
  end

  when_ready(client, request)
end

---Eagerly start and warm the oxfmt client for a buffer's project (background).
---Call this on `FileType` for supported files so the first real format-on-save
---is already warm instead of paying the one-time config-eval cost.
---@param buf integer
function M.ensure(buf)
  local client, root = client_for(buf)
  if not client or not root then
    return
  end
  if warmed[root] then
    return
  end
  warmed[root] = true
  -- Fire a throwaway formatting request to trigger vite.config.ts evaluation.
  -- The result is discarded; the point is to warm the server's config cache.
  when_ready(client, function()
    local params = {
      textDocument = { uri = vim.uri_from_bufnr(buf) },
      options = {
        tabSize = vim.bo[buf].shiftwidth or 2,
        insertSpaces = vim.bo[buf].expandtab ~= false,
      },
    }
    client:request("textDocument/formatting", params, function() end, buf)
  end)
end

return M
