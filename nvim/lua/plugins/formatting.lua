-- Formatting for vite-plus projects.
--
-- Vite+ (`vp fmt`) formats code with oxfmt, reading its config from the `fmt`
-- block of the project's `vite.config.ts` (falling back to `.oxfmtrc.json`).
-- To match `vp fmt` exactly we drive oxfmt through its `--lsp` mode, which
-- evaluates `vite.config.ts` and caches the result. We keep one long-lived
-- oxfmt LSP client per project root (`util.oxfmt_lsp`) so the first format
-- pays a one-time warm-up and every format after is ~0.3ms -- instead of
-- re-spawning the ~1.2s wrapper on every save.
--
-- The formatter is only active inside vite-plus projects (via `condition`).
-- Outside them it is skipped and conform falls back to LSP formatting
-- (`lsp_format = "fallback"`), preserving the previous behavior.

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local vp = require("util.vite_plus")
      local oxfmt_lsp = require("util.oxfmt_lsp")

      opts.formatters = opts.formatters or {}
      -- A Lua formatter (no `command`): conform calls
      -- `config.format(config, ctx, lines, callback)`.
      opts.formatters.oxfmt = {
        format = function(_self, ctx, lines, callback)
          oxfmt_lsp.format(ctx, lines, callback)
        end,
        -- Only active for real files inside vite-plus projects. Unnamed
        -- buffers are skipped (the LSP needs a real file URI).
        condition = function(_self, ctx)
          if vim.api.nvim_buf_get_name(ctx.buf) == "" then
            return false
          end
          return vp.find_root(ctx.dirname) ~= nil
        end,
      }

      -- Prepend `oxfmt` for each supported filetype so it runs first (and,
      -- with LazyVim's `stop_after_first`, wins) in vite-plus projects. In
      -- other projects its `condition` is false, so existing/LSP formatters
      -- keep working unchanged.
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(vp.supported_filetypes) do
        local existing = opts.formatters_by_ft[ft]
        if type(existing) == "table" then
          if not vim.tbl_contains(existing, "oxfmt") then
            opts.formatters_by_ft[ft] = vim.list_extend({ "oxfmt" }, existing)
          end
        else
          opts.formatters_by_ft[ft] = { "oxfmt" }
        end
      end

      -- Warm the oxfmt LSP client (start it + trigger config evaluation) when
      -- a supported file opens in a vite-plus project, so the first real
      -- format-on-save is already fast. Runs in the background via `vim.schedule`.
      local group = vim.api.nvim_create_augroup("oxfmt_lsp_warmup", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = vp.supported_filetypes,
        callback = function(event)
          vim.schedule(function()
            oxfmt_lsp.ensure(event.buf)
          end)
        end,
      })

      return opts
    end,
  },
}
