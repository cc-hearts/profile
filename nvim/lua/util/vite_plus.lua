---Vite+ (`vite-plus` / `vp`) project detection and oxfmt integration.
---
---Vite+ ships its own formatter (`vp fmt`) backed by oxfmt. oxfmt reads its
---config from the `fmt` block of the project's `vite.config.ts` (and, as a
---fallback, `.oxfmtrc.json`). This module locates vite-plus project roots and
---resolves the vite-plus `oxfmt` wrapper (the stdin/IDE-mode entry point that
---makes oxfmt evaluate `vite.config.ts`, matching `vp fmt`).
local M = {}

local uv = vim.uv or vim.loop

---Per-directory cache of "is this directory a vite-plus project root?".
---@type table<string, boolean>
local root_cache = {}

---Filetypes oxfmt supports for stdin formatting (verified against the bundled
---oxfmt binary). Anything not in this list (e.g. `astro`, `lua`, `sh`) is left
---to its default formatter / LSP fallback.
M.supported_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "json",
  "jsonc",
  "css",
  "scss",
  "less",
  "html",
  "markdown",
  "yaml",
}

---Check whether a package.json belongs to a vite-plus project.
---@param package_json string absolute path to package.json
---@return boolean
local function is_vite_plus_package(package_json)
  local ok, contents = pcall(vim.fn.readfile, package_json)
  if not ok or not contents then
    return false
  end

  local ok_decode, pkg = pcall(vim.json.decode, table.concat(contents, "\n"))
  if not ok_decode or type(pkg) ~= "table" then
    return false
  end

  for _, field in ipairs({ "dependencies", "devDependencies", "peerDependencies", "optionalDependencies" }) do
    local deps = pkg[field]
    if type(deps) == "table" then
      for name in pairs(deps) do
        if name == "vite-plus" or name:match("^@vite%-plus/") then
          return true
        end
      end
    end
  end

  if type(pkg.scripts) == "table" then
    for _, script in pairs(pkg.scripts) do
      if type(script) == "string" then
        -- `vite-plus` anywhere, or a bare `vp ` command in a script.
        if script:find("vite%-plus") or script:match("^vp%s") or script:match("[%s;&|]vp%s") then
          return true
        end
      end
    end
  end

  return false
end

---Check whether a directory contains a `vite-plus.config.*` marker file.
---@param dir string
---@return boolean
local function has_vite_plus_config(dir)
  local found = vim.fn.glob(dir .. "/vite-plus.config.*", false, true)
  if type(found) == "table" then
    return found[1] ~= nil
  end
  return found ~= nil and found ~= ""
end

---Is `dir` itself a vite-plus project root?
---@param dir string
---@return boolean
local function is_vite_plus_root(dir)
  if root_cache[dir] ~= nil then
    return root_cache[dir]
  end
  local found = has_vite_plus_config(dir)
    or (uv.fs_stat(dir .. "/package.json") ~= nil and is_vite_plus_package(dir .. "/package.json"))
  root_cache[dir] = found
  return found
end

---Find the nearest enclosing vite-plus project root for a file or directory.
---Walks upward from the given path. Returns nil when not inside a vite-plus
---project.
---@param path string? file or directory path (defaults to cwd)
---@return string|nil root
function M.find_root(path)
  path = vim.fs.normalize(path or vim.fn.getcwd())
  local dir = path
  local st = uv.fs_stat(path)
  if st and st.type ~= "directory" then
    dir = vim.fs.dirname(path)
  end

  while dir and dir ~= "" do
    if is_vite_plus_root(dir) then
      return dir
    end
    local parent = vim.fs.dirname(dir)
    if parent == dir then
      break
    end
    dir = parent
  end
  return nil
end

---Whether a file/directory belongs to a vite-plus project.
---@param path string?
---@return boolean
function M.is_vite_plus(path)
  return M.find_root(path) ~= nil
end

---Per-root cache of the resolved oxfmt wrapper path (or false).
---@type table<string, string|false>
local oxfmt_cmd_cache = {}

---Resolve the oxfmt executable to drive formatting with.
---
---IMPORTANT: this returns the **vite-plus `oxfmt` wrapper**, NOT the raw
---bundled oxfmt binary. `vp fmt` reads the project's `fmt` config from
---`vite.config.ts` (the `fmt` block), and oxfmt only does that when launched
---through this wrapper in stdin/IDE mode (it sets `VP_VERSION` /
---`VP_RESOLVING_CONFIG_METADATA`, which makes oxfmt evaluate `vite.config.ts`).
---The raw `oxfmt` binary only reads `.oxfmtrc.json` and would diverge from
---`vp fmt` (e.g. quote style). Returns nil when vite-plus is not installed.
---
---Candidates: the top-level hoist (`~/.vite-plus/current`, stable across vp
---versions thanks to the `current` symlink), then the project's own
---`node_modules` (hoisted or pnpm store) so projects that don't install
---vite-plus globally still resolve their local wrapper.
---@param root string? vite-plus project root (defaults to cwd)
---@return string|nil
function M.oxfmt_command(root)
  root = vim.fs.normalize(root or vim.fn.getcwd())
  if oxfmt_cmd_cache[root] ~= nil then
    return oxfmt_cmd_cache[root] or nil
  end

  local home = vim.fn.expand("~")
  local candidates = {
    home .. "/.vite-plus/current/node_modules/vite-plus/bin/oxfmt",
    root .. "/node_modules/vite-plus/bin/oxfmt",
    root .. "/node_modules/.pnpm/vite-plus@*/node_modules/vite-plus/bin/oxfmt",
  }
  local globs = vim.fn.glob(
    home .. "/.vite-plus/current/node_modules/.pnpm/vite-plus@*/node_modules/vite-plus/bin/oxfmt",
    false,
    true
  )
  if type(globs) == "table" then
    vim.list_extend(candidates, globs)
  elseif type(globs) == "string" and globs ~= "" then
    table.insert(candidates, globs)
  end

  for _, p in ipairs(candidates) do
    if vim.fn.executable(p) == 1 then
      oxfmt_cmd_cache[root] = p
      return p
    end
  end

  oxfmt_cmd_cache[root] = false
  return nil
end

return M
