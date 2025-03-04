local function is_project_disabled_formatting()
  local disable_formatting_projects = {}
  local cwd = vim.fn.getcwd()
  for _, project_path in ipairs(disable_formatting_projects) do
    if cwd:find(project_path, 1, true) then
      return true
    end
  end
  return false
end

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

        opts.on_attach = function(client, bufnr)
          -- 检查项目中是否存在 eslint 或 prettier 配置文件
          local function has_eslint_or_prettier_config()
            local eslint_config_files =
              { ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".eslintrc.yml", ".eslintrc.yaml", "eslint.config.js" }
            local prettier_config_files =
              { ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.yml", ".prettierrc.yaml" }

            -- 遍历 eslint 配置文件
            for _, file in ipairs(eslint_config_files) do
              if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
                return true
              end
            end

            -- 遍历 prettier 配置文件
            for _, file in ipairs(prettier_config_files) do
              if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
                return true
              end
            end

            return false
          end

          if has_eslint_or_prettier_config() then
            -- 如果存在 eslint 或 prettier 配置，禁用 tsserver 的格式化功能
            client.server_capabilities.documentFormattingProvider = false
          else
            -- 如果没有 eslint 或 prettier 配置，启用 eslint 的格式化
            client.server_capabilities.documentFormattingProvider = true
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end
        end
      end,

      eslint = function(_, opts)
        require("lazyvim.util").lsp.on_attach(function(client, bufnr)
          if is_project_disabled_formatting() then
            client.server_capabilities.documentFormattingProvider = false
            return
          end

          -- 仅启用 eslint 格式化
          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          else
            client.server_capabilities.documentFormattingProvider = false
          end
        end)
      end,

      volar = function(_, opts)
        local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
        local has_eslint_or_prettier = false

        for _, client in ipairs(clients) do
          if client.name == "eslint" or client.name == "prettier" then
            has_eslint_or_prettier = true
            break
          end
        end

        if has_eslint_or_prettier or is_project_disabled_formatting() then
          opts.format = opts.format or {}
          opts.format.enable = false
        end

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
