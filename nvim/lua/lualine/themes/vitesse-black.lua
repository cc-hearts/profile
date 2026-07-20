-- lualine 主题：vitesse-black
-- lualine 设为 theme = "auto" 时会自动加载本文件
local p = {
  bg = "#000000",
  fg1 = "#bfbaaa", -- 活动前景
  fg2 = "#959da5", -- 次要
  fg3 = "#6e6e6e", -- 非活动
  green = "#4d9375",
  green_l = "#80a665",
  blue = "#6394bf",
  orange = "#d4976c",
  red = "#cb7676",
  cyan = "#5eaab5",
  bg1 = "#121212",
}

-- mode: a = 模式块（黑字彩底），b/c 不设底色，适配透明与非透明
return {
  normal = {
    a = { fg = "#000000", bg = p.green, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  insert = {
    a = { fg = "#000000", bg = p.green_l, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  visual = {
    a = { fg = "#000000", bg = p.blue, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  command = {
    a = { fg = "#000000", bg = p.orange, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  replace = {
    a = { fg = "#000000", bg = p.red, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  terminal = {
    a = { fg = "#000000", bg = p.cyan, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  inactive = {
    a = { fg = p.fg3 },
    b = { fg = p.fg3 },
    c = { fg = p.fg3 },
  },
}
