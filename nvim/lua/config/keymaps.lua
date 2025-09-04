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

keymap.set("n", "<leader>ft", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })

  vim.schedule(function()
    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "terminal" then
      vim.cmd("resize 10")
    end
  end)
end, { desc = "Terminal (Root Dir + resize 10)" })

keymap.set("n", "<leader>ft", function()
  Snacks.terminal(nil, { cwd = vim.fn.getcwd() })

  vim.schedule(function()
    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "terminal" then
      vim.cmd("resize 10")
    end
  end)
end, { desc = "Terminal (Root Dir + resize 10)" })

vim.keymap.set("n", "<leader>fe", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
end)

