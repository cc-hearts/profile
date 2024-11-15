return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
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
      eslint = function(_, opts)
        require("lazyvim.util").lsp.on_attach(function(client, bufnr)
          client.server_capabilities.documentRangeFormattingProvider = true
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
            print("hello")
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          elseif client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,
    },
  },
}