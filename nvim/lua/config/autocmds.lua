-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "typescriptreact",
    "javascriptreact",
    "typescript",
    "javascript",
    "json",
    "jsonc",
    "sass",
    "scss",
    "markdown",
  },
  callback = function()
    local eslint_config_file = "eslint.config.js"
    local rood_dir = vim.fn.getcwd()
    if vim.loop.fs_stat(rood_dir .. "/" .. eslint_config_file) then
      vim.b.autoformat = false
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*",
  callback = function()
    vim.bo.fileformat = "unix"
  end,
})