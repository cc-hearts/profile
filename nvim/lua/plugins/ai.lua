return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    build = "make",
    opts = {
      -- add any opts here
      -- for example
      provider = "groq",
      auto_suggestions_provider = "groq",
      providers = {
        groq = {
          __inherited_from = "openai",
          api_key_name = "AI_API_KEY",
          endpoint = "https://www.openai.com/v1",
          model = "gpt-4o-mini",
          timeout = 30000, -- timeout in milliseconds
          -- temperature = 0, -- adjust if needed
          -- max_tokens = 4096,
        },
      },
    },
  },
  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("codeium").setup({})
    end,
  },
}
