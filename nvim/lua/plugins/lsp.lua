return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/typescript.nvim",
        init = function()
          require("lazyvim.util").lsp.on_attach(function(_, buffer)
            vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
            vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { buffer = buffer, desc = "Rename File" })
          end)
        end,
      },
    },
    ---@class PluginLspOpts
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Pyright
      opts.servers.pyright = opts.servers.pyright or {}

      -- tsserver 配置
      opts.servers.tsserver = opts.servers.tsserver or {}

      -- volar 配置
      opts.servers.volar = {
        init_options = {
          vue = {
            hybridMode = true,
          },
        },
      }

      -- vtsls 配置
      opts.servers.vtsls = opts.servers.vtsls or {}
      opts.servers.vtsls.filetypes = opts.servers.vtsls.filetypes or {}
      table.insert(opts.servers.vtsls.filetypes, "vue")

      LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@vue/typescript-plugin",
          location = LazyVim.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
          languages = { "vue" },
          configNamespace = "typescript",
          enableForWorkspaceTypeScriptVersions = true,
        },
      })

      -- 统一的 setup 配置
      opts.setup = opts.setup or {}
      opts.setup.tsserver = function(_, ts_opts)
        require("typescript").setup({ server = ts_opts })
        return true
      end
    end,
  }
}
