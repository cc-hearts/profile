return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options.section_separators = { right = "", left = "" }
      opts.options.component_separators = { right = "", left = "" }

      table.insert(opts.sections.lualine_x, "😄")
    end,
  },
}

