-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local function open_terminal_at_root(is_vertical)
  local position
  if is_vertical then
    position = "right"
  else
    position = "bottom"
  end
  Snacks.terminal.open(nil, { win = { position = position, width = 10, height = 10 } })
end

local function is_windows()
  return package.config:sub(1, 1) == "\\"
end

vim.o.title = true
vim.o.titlestring = "%<%{fnamemodify(getcwd(), ':t')}"
--
vim.schedule(function()
  if is_windows() then
    vim.o.shell = "powershell.exe"
    vim.o.shellcmdflag = "-NoLogo"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
  end

  open_terminal_at_root()

  vim.cmd("stopinsert")

  vim.cmd("Neotree")
end)

-- local function get_system_theme()
--   if vim.fn.has("mac") == 1 then
--     local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
--     local result = handle:read("*a")
--     handle:close()
--     return result:match("Dark") and "dark" or "light"
--   elseif vim.fn.has("win32") == 1 then
--     local handle =
--       io.popen("reg query HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize /v AppsUseLightTheme")
--     local result = handle:read("*a")
--     handle:close()
--     return result:match("0x1") and "light" or "dark"
--   end
--   return "dark"
-- end
--
-- local function apply_theme()
--   local sys_theme = get_system_theme()
--   if sys_theme ~= vim.o.background then
--     vim.cmd("ToggleTheme")
--   end
-- end
--
-- vim.api.nvim_create_user_command("ToggleTheme", function()
--   if vim.o.background == "dark" then
--     vim.o.background = "light"
--     vim.cmd.colorscheme("catppuccin-latte")
--   else
--     vim.o.background = "dark"
--     vim.cmd.colorscheme("catppuccin-mocha")
--   end
-- end, {})
--
-- -- 定时检查系统主题变化
-- vim.loop.new_timer():start(0, 5000, vim.schedule_wrap(apply_theme))
