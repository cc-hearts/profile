return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = true, -- handled by nvim-cmp / blink.cmp
          next = "<C-j>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
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
