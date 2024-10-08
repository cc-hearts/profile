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

function ConditionalCloseAllBuffers()
    local current_buf = vim.api.nvim_get_current_buf()
    local buf_ft = vim.api.nvim_buf_get_option(current_buf, 'filetype')

    -- 如果当前 buffer 是 nvim-tree 或者 zsh;#toggleterm，则不执行任何操作
    if buf_ft == 'NvimTree' or buf_ft == 'toggleterm' then
        print('Current buffer is either NvimTree or toggleterm, <leader>qa is disabled.')
        return
    end

    local bufs = vim.api.nvim_list_bufs()

    for _, buf in ipairs(bufs) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
            local current_buf = vim.api.nvim_get_current_buf()
            local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')
            -- 保留 nvim-tree 和 zsh;#toggleterm buffer
            if buf ~= current_buf and buf_ft ~= 'NvimTree' and buf_ft ~= 'toggleterm' then
                vim.api.nvim_buf_delete(buf, {force = true})
            end
        end
    end
end

vim.api.nvim_set_keymap('n', '<leader>qa', ':lua ConditionalCloseAllBuffers()<CR>', {
    noremap = true,
    silent = true
})


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


vim.api.nvim_set_keymap('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })