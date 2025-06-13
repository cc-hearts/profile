return {
  {
    "saghen/blink.cmp",
    event = { "BufNewFile", "BufReadPost" },
    version = "1.*",
    opts = {
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
      },
      signature = {
        enabled = true,
      },
    },
  },
}
