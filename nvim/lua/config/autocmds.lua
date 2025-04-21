-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*",
  callback = function()
    vim.bo.fileformat = "unix"
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  callback = function(args)
    local file = args.file
    local size = vim.fn.getfsize(file)
    if size > 1024 * 1024 * 2 then -- > 2MB 可自调
      vim.b.large_file = true
      vim.cmd("syntax off")
      vim.cmd("filetype off")
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.lazyredraw = true
      vim.opt_local.eventignore = "all"
    end
  end,
})
