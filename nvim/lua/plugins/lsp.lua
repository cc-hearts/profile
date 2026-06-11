return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- vue_ls（Vue SFC 模板/脚本语言服务）
      opts.servers.vue_ls = opts.servers.vue_ls or {}

      -- vtsls + @vue/typescript-plugin（让 TS 识别 .vue 文件）
      opts.servers.vtsls = opts.servers.vtsls or {}

      local vtsls = opts.servers.vtsls
      vtsls.filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
      }

      vtsls.settings = vim.tbl_deep_extend("force", vtsls.settings or {}, {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = "@vue/typescript-plugin",
                location = vim.fn.stdpath("data")
                  .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
                languages = { "vue" },
                configNamespace = "typescript",
                enableForWorkspaceTypeScriptVersions = true,
              },
            },
          },
        },
      })

      -- =========================
      -- 自定义 keymaps
      -- =========================
      opts.on_attach = function(_, bufnr)
        local map = vim.keymap.set

        map("n", "<leader>ca", vim.lsp.buf.code_action, {
          buffer = bufnr,
          desc = "Code Action",
        })

        map("n", "<leader>cr", vim.lsp.buf.rename, {
          buffer = bufnr,
          desc = "Rename",
        })

        map("n", "<leader>co", function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "source.organizeImports" },
            },
          })
        end, { buffer = bufnr, desc = "Organize Imports" })
      end
    end,
  },
}
