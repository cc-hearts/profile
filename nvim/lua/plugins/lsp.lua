return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "jose-elias-alvarez/typescript.nvim",
    init = function()
      require("lazyvim.util").lsp.on_attach(function(_, buffer)
        -- stylua: ignore
        vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
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
          "vue",
          "typescript.tsx",
        },
        root_dir = vim.uv.cwd,
      },
      eslint = {
        settings = {
          -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
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
          "gql",
          "graphql",
          "astro",
          "svelte",
          "css",
          "less",
          "scss",
        },
      },
    },
    setup = {
      tsserver = function(_, opts)
        require("typescript").setup({ server = opts })
        return true
      end,

      eslint = function(_, opts)
        require("lazyvim.util").lsp.on_attach(function(client, bufnr)
          client.server_capabilities.documentRangeFormattingProvider = true
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          elseif client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,

      volar = function(_, opts)
        -- 获取当前缓冲区的 LSP 客户端列表
        local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })

        -- 检查是否有 ESLint 或 Prettier 客户端
        local has_eslint_or_prettier = false
        for _, client in ipairs(clients) do
          if client.name == "eslint" or client.name == "prettier" then
            has_eslint_or_prettier = true
            break
          end
        end

        -- 如果存在 ESLint 或 Prettier，则禁用 Volar 的格式化功能
        if has_eslint_or_prettier then
          opts.format = opts.format or {}
          opts.format.enable = false
        end
      end
    },
  },
}
