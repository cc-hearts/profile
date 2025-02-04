-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local function open_terminal_at_root(is_vertical)
  local position
  if is_vertical then
    position = "right"
  else
    position = "bottom"
  end
  Snacks.terminal.open(nil, { win = { position = position, width = 30 } })
end

vim.schedule(function()
  open_terminal_at_root()

  vim.cmd("resize 15")
  vim.cmd("stopinsert")

  vim.cmd("wincmd w") -- 切换到另一个窗口
  vim.cmd("wincmd l") -- 然后调整窗口

  vim.cmd("Neotree")
end)
