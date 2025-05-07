-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

keymap.set("n", "dw", 'vb"_d')

keymap.set("n", "<C-a>", "gg<S-v>G")

keymap.set({ "n", "v" }, "gh", "^")
keymap.set({ "v", "n" }, "gl", "$")

-- Buffer 左右移动快捷键
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" }) -- 左移动
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" }) -- 右移动-
