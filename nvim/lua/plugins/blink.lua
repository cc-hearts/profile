return {
  "saghen/blink.cmp",
  ---@module 'blink.cmp'
  ---@type fun(_: any, opts: blink.cmp.Config):blink.cmp.Config
  opts = function(_, opts)
    opts.keymap["<C-n>"] = {
      "show",
      "select_next",
    }

    opts.completion.accept.auto_brackets = { enabled = false }
    opts.completion.menu.min_width = 24
    opts.completion.menu.draw.treesitter = {}

    return opts
  end,
}