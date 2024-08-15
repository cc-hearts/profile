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
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')}]]
option.signcolumn = "yes"

option.swapfile = false
option.backup = false
option.updatetime = 50
option.mouse = ""
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

vim.keymap.set('i', '<C-v>', '<ESC>l"+Pli') -- Paste insert mode
vim.keymap.set('i', '<C-z>', '<Esc>:undo<CR>', {
    noremap = true,
    silent = true
})

vim.keymap.set('v', '<C-c>', '"+y', {
    noremap = true,
    silent = true
}) -- save
vim.keymap.set('v', '<C-v>', '"+P', {
    noremap = true,
    silent = true
}) -- Paste visual mode

vim.keymap.set('n', '<C-s>', ':w<CR>', {
    noremap = true,
    silent = true
}) -- Save
vim.keymap.set('n', '<C-v>', '"+P', {
    noremap = true,
    silent = true
}) -- Paste normal mode
vim.keymap.set('n', '<C-z>', '<Nop>', {
    noremap = true,
    silent = true
})

function close_non_current_buffers()
    local current_buf = vim.api.nvim_get_current_buf()
    -- 获取所有 buffer 的列表
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) then
            -- 关闭所有非当前 buffer
            vim.api.nvim_buf_delete(buf, {
                force = true
            })
        end
    end
end
vim.api.nvim_set_keymap('n', '<leader>qa', ':lua close_non_current_buffers()<CR>', {
    noremap = true,
    silent = true
})

local function close_and_switch_to_previous_buffer()
    -- 获取当前 buffer 的编号
    local current_bufnr = vim.fn.bufnr()

    -- 执行关闭 buffer 的操作，并自动切换到前一个 buffer
    vim.cmd('bprevious')
    vim.cmd('bd ' .. current_bufnr)
  end

  -- 设置 <leader>q 快捷键
  vim.api.nvim_set_keymap('n', '<leader>q', ':lua close_and_switch_to_previous_buffer()<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<C-h>', '<C-w>h', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', '<C-j>', '<C-w>j', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', '<C-k>', '<C-w>k', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', '<C-l>', '<C-w>l', {
    noremap = true,
    silent = true
})

vim.keymap.set("n", "<leader>mn", "<cmd>bnext<CR>", {
    silent = true
})
vim.keymap.set("n", "<leader>mm", "<cmd>bprevious<CR>", {
    silent = true
})
vim.keymap.set("n", "<leader>bn", "<cmd>bn<CR>")
vim.keymap.set("n", "<leader>bm", "<cmd>bp<CR>")
vim.keymap.set("n", "<leader>bc", "<cmd>bd<CR>")
vim.keymap.set('n', '<leader>tt', ':ToggleTerm<CR>', {
    noremap = true,
    silent = true
})


vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>', {
    noremap = true,
    silent = true
})
