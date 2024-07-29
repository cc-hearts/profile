-- local varaible --
local option = vim.opt
local buffer = vim.b
local global = vim.g

-- global settings --
option.showmode = false

-- unknown --
option.autoindent = true
option.smartindent = true
option.shiftround = true
option.termguicolors = true
-- tab --
option.expandtab = ture
option.tabstop = 2
option.shiftwidth = 2

option.number = true
option.relativenumber = true
option.wildmenu = true
option.completeopt = {"menuone", "noselect"}
option.guifont = "CascadiaCode"
option.hlsearch = false
option.ignorecase = true
option.smartcase = true

option.cursorline = true

option.autoread = true
option.title = true
option.signcolumn = "yes"

option.swapfile = false
option.backup = false
option.updatetime = 50
option.mouse = "a"
option.undofile = true
option.undodir = vim.fn.expand('$HOME/.local/share/nvim/undo')
option.exrc = true
-- close wrap --
option.wrap = false
option.splitright = true

-- buffer settings --
buffer.fileencoding = "utf-8"

-- global settings --
global.mapleader = " "

-- key mappings --
vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
vim.keymap.set('v', '<D-c>', '"+y') -- Copy
vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode

vim.keymap.set("n", "<leader>mn", "<cmd>bnext<CR>", {
    silent = true
})
vim.keymap.set("n", "<leader>mm", "<cmd>bprevious<CR>", {
    silent = true
})
vim.keymap.set("n", "<leader>bn", "<cmd>bn<CR>")
vim.keymap.set("n", "<leader>bm", "<cmd>bp<CR>")
vim.keymap.set("n", "<leader>bc", "<cmd>bd<CR>")
