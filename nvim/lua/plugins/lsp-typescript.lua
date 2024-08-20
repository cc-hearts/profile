return {
    'pmizio/typescript-tools.nvim',
    dependencies = {'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig', 'stevearc/conform.nvim'},
    config = function()
        local api = require 'typescript-tools.api'
        require('typescript-tools').setup {
            -- 是否隐藏 没有使用的变量提示
            -- handlers = {
            --   ['textDocument/publishDiagnostics'] = api.filter_diagnostics { 6133 },
            -- },
            settings = {
                tsserver_plugins = { -- Seemingly this is enough, no name, location or languages needed.
                  "@vue/typescript-plugin"
                },

                tsserver_file_preferences = {
                    importModuleSpecifierPreference = 'non-relative'
                },
                disable_member_code_lens = false
            },
            filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact",
                         "typescript.tsx"
            }
        }

        -- local autocmd = vim.api.nvim_create_autocmd
        autocmd('BufWritePre', {
            pattern = '*.ts,*.tsx,*.jsx,*.js',
            callback = function(args)
                vim.cmd 'TSToolsAddMissingImports sync'
                vim.cmd 'TSToolsOrganizeImports sync'
                require('conform').format {
                    bufnr = args.buf
                }
            end
        })
    end
}
