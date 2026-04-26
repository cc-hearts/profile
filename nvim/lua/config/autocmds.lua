-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  callback = function(args)
    local file = args.file
    local size = vim.fn.getfsize(file)
    if size > 1024 * 1024 * 2 then -- > 2MB 可自调
      vim.b.large_file = true
      vim.b.autoformat = false
      vim.cmd("syntax off")
      vim.cmd("filetype off")
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.lazyredraw = true
      vim.opt_local.eventignore = "all"
      vim.diagnostic.enable(false, { bufnr = args.buf })
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if not vim.b[args.buf].large_file then
      return
    end

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client:stop()
    end
  end,
})
