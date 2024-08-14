return {
  {
    "brenton-leighton/multiple-cursors.nvim",
    version = "*",
    opts = {},
    keys = {
      {"<C-j>", "<Cmd>MultipleCursorsAddDown<CR>",mode = {"i"}},
      {"<C-k>", "<Cmd>MultipleCursorsAddUp<CR>",  mode = {'i'}},
      {"<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = {"i"}},
    },
  },
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  {
    'numToStr/Comment.nvim',
    opts = {
        -- add any options here
    }
}
}