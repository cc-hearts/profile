return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "jose-elias-alvarez/typescript.nvim",
    init = function()
      require("lazyvim.util").lsp.on_attach(function(_, buffer)
        vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
        vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
      end)
    end,
  },
  opts = {
    servers = {
      pyright = {},
      tsserver = {},
      cssmodules_ls = {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        root_dir = vim.uv.cwd,
      },
      eslint = {
        settings = {
          workingDirectories = { mode = "auto" },
        },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
          "html",
          "markdown",
          "json",
          "jsonc",
          "yaml",
          "toml",
          "xml",
          "css",
          "less",
          "scss",
        },
      },
    },
    setup = {
      -- eslint = function(_, opts)
      --   require("lazyvim.util").lsp.on_attach(function(client, bufnr)
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       buffer = bufnr,
      --       command = "EslintFixAll",
      --     })
      --   end)
      -- end,

      vtsls = function(_, opts)
        opts.format = opts.format or {}
        opts.format.enable = false
        -- end

        opts.settings = opts.settings or {}
        opts.settings.css = {
          lint = {
            unknownAtRules = "ignore",
          },
        }
        opts.settings.scss = {
          lint = {
            unknownAtRules = "ignore",
          },
        }
      end,
    },
  },
}
