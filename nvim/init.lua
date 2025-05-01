-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.o.title = true
vim.o.titlestring = "%<%{fnamemodify(getcwd(), ':t')}"
