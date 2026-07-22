local M = {}

local command = { "defaults", "read", "-g", "AppleInterfaceStyle" }
local timer
local checking = false

local function supported()
  return vim.fn.has("macunix") == 1 and vim.fn.executable("defaults") == 1
end

local function result_is_dark(result)
  return result.code == 0 and vim.trim(result.stdout or ""):lower() == "dark"
end

local function theme_name(is_dark)
  return is_dark and "vitesse-black" or "vitesse-light-soft"
end

local function apply(is_dark)
  local colorscheme = theme_name(is_dark)
  if vim.g.colors_name ~= colorscheme then
    vim.cmd.colorscheme(colorscheme)
  end
end

function M.colorscheme()
  if not supported() then
    return theme_name(vim.o.background == "dark")
  end

  return theme_name(result_is_dark(vim.system(command, { text = true }):wait()))
end

function M.sync()
  if not supported() or checking then
    return
  end

  checking = true
  vim.system(command, { text = true }, function(result)
    vim.schedule(function()
      checking = false
      apply(result_is_dark(result))
    end)
  end)
end

function M.start()
  if not supported() or timer then
    return
  end

  local group = vim.api.nvim_create_augroup("vitesse_system_theme", { clear = true })
  vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = M.sync,
    desc = "Sync Vitesse with the macOS appearance",
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    once = true,
    callback = function()
      if timer then
        timer:stop()
        timer:close()
        timer = nil
      end
    end,
  })

  timer = assert(vim.uv.new_timer())
  timer:start(2000, 2000, vim.schedule_wrap(M.sync))
end

return M
