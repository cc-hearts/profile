-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

keymap.set("n", "dw", 'vb"_d')

keymap.set("n", "<C-a>", "<Cmd>lua MiniAnimate.execute_after('scroll', 'normal! gg<S-v>G')<CR>")

keymap.set({ "n", "v" }, "gh", "^")
keymap.set({ "v", "n" }, "gl", "$")

keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open DiffView" })
keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close DiffView" })
keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<CR>", { desc = "File History" })