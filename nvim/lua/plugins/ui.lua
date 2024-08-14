return {{
    "akinsho/bufferline.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require("bufferline").setup({})
    end
}, {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = true
}, {
    "lewis6991/gitsigns.nvim",
    config = true
}, {
    "goolord/alpha-nvim",
    config = function()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
}, {
    "RRethy/vim-illuminate",
    config = function()
        require('illuminate').configure()
    end
}, {
    "nvim-telescope/telescope.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end
}, {
    "nvim-tree/nvim-tree.lua",
    after = "nvim-web-devicons",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
        -- 映射快捷键以打开和关闭 nvim-tree
        vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', {
            noremap = true,
            silent = true
        })

        require('nvim-tree').setup({

            -- view = {
            --     side = 'right', -- 可以是 'left', 'right', 'top', 或 'bottom'
            --     width = 50 -- 树的宽度
            -- },

            update_cwd = true,
            update_focused_file = {
                enable = true,
                update_cwd = true
            },
            git = {
                enable = true, -- 启用 Git 状态
                ignore = false -- 不忽略 Git 忽略的文件
            },
            system_open = {
                cmd = 'open' -- windows 直接设置为 wsl-open npm install -g wsl-open
            }
        })
    end
}, {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
        vim.opt.laststatus = 3
        vim.opt.splitkeep = "screen"
    end,
    config = function()
        require("edgy").setup({
            animate = {
                enabled = false -- 禁用动画
            },

            options = {
                left = {
                    size = 40
                },
                bottom = {
                    size = 5
                },
                right = {
                    size = 40
                },
            },

            bottom = {{
                ft = "toggleterm",
                -- exclude floating windows
                filter = function(buf, win)
                    return vim.api.nvim_win_get_config(win).relative == ""
                end
            }},

            right = { -- 可以在右侧配置窗口
            {
                ft = "NvimTree",
                open = function()
                    vim.cmd("NvimTreeOpen")
                end
            }}
        })
    end

}}

