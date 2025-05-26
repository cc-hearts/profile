return {
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    enabled = true,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      return {
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          -- 替换成无 LuaSnip 的 tab 行为（不建议长期这样）
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- 不使用 <CR>
        }),
        sources = cmp.config.sources({
          { name = "codeium" }, -- 放在前面优先触发
          { name = "lazydev" },
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),

        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              codeium = "[AI]",
              nvim_lsp = "[LSP]",
              buffer = "[BUF]",
              path = "[PATH]",
            })[entry.source.name]
            return vim_item
          end,
        },

        experimental = {
          ghost_text = true, -- 显示 Codeium inline ghost 提示
        },
      }
    end,
    main = "lazyvim.util.cmp",
  },
}
