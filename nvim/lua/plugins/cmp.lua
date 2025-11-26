return {
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.compat" },
    event = { "BufNewFile", "BufReadPost" },
    version = "1.*",
    opts = {
      enabled = function()
        return vim.bo.buftype == ""
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
        default = { "lsp", "path", "snippets", "buffer" },
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
