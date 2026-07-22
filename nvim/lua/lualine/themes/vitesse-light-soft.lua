-- lualine theme for vitesse-light-soft
local p = {
  fg1 = "#4e4f47",
  fg2 = "#6a737d",
  fg3 = "#a0a19d",
  green = "#1e754f",
  green_l = "#59873a",
  blue = "#296aa3",
  orange = "#a65e2b",
  red = "#ab5959",
  cyan = "#2993a3",
}

-- Mode blocks use white text on the darker Vitesse Light accents.
return {
  normal = {
    a = { fg = "#ffffff", bg = p.green, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  insert = {
    a = { fg = "#ffffff", bg = p.green_l, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  visual = {
    a = { fg = "#ffffff", bg = p.blue, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  command = {
    a = { fg = "#ffffff", bg = p.orange, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  replace = {
    a = { fg = "#ffffff", bg = p.red, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  terminal = {
    a = { fg = "#ffffff", bg = p.cyan, gui = "bold" },
    b = { fg = p.fg1 },
    c = { fg = p.fg2 },
  },
  inactive = {
    a = { fg = p.fg3 },
    b = { fg = p.fg3 },
    c = { fg = p.fg3 },
  },
}
