-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"typescriptreact", "javascriptreact", "typescript", "javascript", "json", "jsonc", "sass", "scss", "vue", "markdown"},
  callback = function()
    local eslint_config_file = "eslint.config.js"
    local prettier_config_file = ".prettierrc"
    local root_dir = vim.fn.getcwd()

    -- 缓存配置文件存在的检查结果到缓冲区
    vim.b.has_eslint_config = vim.loop.fs_stat(root_dir .. "/" .. eslint_config_file) ~= nil
    vim.b.has_prettierrc = vim.loop.fs_stat(root_dir .. "/" .. prettier_config_file) ~= nil

  end
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*"},
  callback = function()

    local is_eslint = vim.b.has_eslint_config or false
    local is_prettierrc = vim.b.has_prettierrc or false

    vim.b.autoformat = not (is_eslint or is_prettierrc)
  end
})
