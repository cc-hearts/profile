return {
  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({})
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    build = "make",
    opts = {
      -- add any opts here
      -- for example
      provider = "grok",
      vendors = {
        grok = {
          __inherited_from = "openai",
          api_key_name = "AI_API_KEY",
          endpoint = "https://api.openai.com/v1",
          model = "grok-3-mini",
          timeout = 30000, -- timeout in milliseconds
          temperature = 0, -- adjust if needed
          -- max_tokens = 4096,
        },
      },
    },
  },

}
