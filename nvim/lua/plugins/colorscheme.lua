-- 本地 Vitesse Soft 主题（零依赖），跟随 macOS 的 light/dark 外观。
-- 不再依赖 2nthony/vitesse.nvim 和 colorbuddy.nvim
local system_theme = require("util.system_theme")

return {
  {
    "LazyVim",
    init = system_theme.start,
    opts = { colorscheme = system_theme.colorscheme() },
  },
}
