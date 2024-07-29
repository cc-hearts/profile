return {{
    "2nthony/vitesse.nvim",
    dependencies = {"tjdevries/colorbuddy.nvim", "nvim-lualine/lualine.nvim", "nvim-tree/nvim-web-devicons",
                    "utilyre/barbecue.nvim", "SmiteshP/nvim-navic"},
    config = function()
        require('vitesse').setup({
            -- ...
        })

        vim.cmd('colorscheme vitesse')

        require('lualine').setup({
            options = {
                theme = "vitesse"
            }
        })
        require("barbecue").setup({
            theme = "vitesse"
        })
    end
}}
