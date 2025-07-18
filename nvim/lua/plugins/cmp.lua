return {
  {
    "saghen/blink.cmp",
    dependencies = { "Saghen/blink.compat", "Exafunction/codeium.nvim" },
    event = { "BufNewFile", "BufReadPost" },
    version = "1.*",
    opts = {
      -- 控制整个 blink 的启用
      enabled = function()
        -- 禁用 prompt 类型 buffer 和非普通 buffer
        return vim.bo.buftype == ""
          -- 可选：禁用特定 filetype，如 Telescope prompt
          and not vim.tbl_contains({ "TelescopePrompt", "DressingInput" }, vim.bo.filetype)
      end,
      keymap = {
        ["<C-n>"] = {
          "show",
          "select_next",
        },
      },
      completion = {
        documentation = { auto_show = true },
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        menu = {
          min_width = 24,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "codeium" },
        providers = {
          codeium = { name = "Codeium", module = "codeium.blink", async = true },
        },
        compat = {
          "avante_commands",
          "avante_mentions",
          "avante_files",
        },
      },
      signature = {
        enabled = true,
      },
    },
  },
}
