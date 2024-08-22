return {
  {
    "brenton-leighton/multiple-cursors.nvim",
    version = "*",
    opts = {},
    keys = {
      {"<C-j>", "<Cmd>MultipleCursorsAddDown<CR>",mode = {"i"}},
      {"<C-k>", "<Cmd>MultipleCursorsAddUp<CR>",  mode = {'i'}},
      {"<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = {"i"}},
    },
  },
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  {
    'numToStr/Comment.nvim',
    opts = {
        -- add any options here
    }
},
{
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { "rustfmt", lsp_format = "fallback" },
      -- Conform will run the first available formatter
      javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  },
},
}