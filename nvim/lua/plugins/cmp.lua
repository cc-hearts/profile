return {
  {
    "saghen/blink.cmp",
    dependencies = { "Saghen/blink.compat", "Exafunction/codeium.nvim" },
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
