-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.o.title = true
vim.o.titlestring = "%<%{fnamemodify(getcwd(), ':t')}"

local function is_windows()
  return package.config:sub(1, 1) == "\\"
end

if is_windows() then
  vim.o.shell = "powershell.exe"
  vim.o.shellcmdflag = "-NoLogo"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
end
