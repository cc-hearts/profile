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
  }
}