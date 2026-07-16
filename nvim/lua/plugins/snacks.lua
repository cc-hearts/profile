return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
          -- VSCode-like literal grep: `<leader>sg` / `<leader>sG` / `<leader>sB`
          -- match the text as-is (rg --fixed-strings) instead of regex.
          -- Press <Alt-r> in the picker to toggle regex mode (the `R` indicator
          -- lights up). `grep_word` (<leader>sw) is already literal by default.
          grep = { regex = false },
          grep_buffers = { regex = false },
        },
      },
    },
  },
}
