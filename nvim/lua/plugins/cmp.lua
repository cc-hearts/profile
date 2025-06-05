return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
