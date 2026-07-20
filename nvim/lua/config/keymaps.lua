-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

keymap.set("n", "dw", 'vb"_d')

keymap.set("n", "<C-a>", "gg<S-v>G")

keymap.set({ "n", "v" }, "gh", "^")
keymap.set({ "v", "n" }, "gl", "$")

-- Buffer keymaps
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" }) -- 左移动
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" }) -- 右移动-

keymap.set("n", "<leader>ft", function()
  vim.schedule(function()
    Snacks.terminal(nil, { cwd = vim.fn.getcwd() })
    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "terminal" then
      vim.cmd("resize 10")
    end
  end)
end, { desc = "Terminal (Root Dir + resize 10)" })

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })

vim.keymap.set("n", "<leader>cF", "<cmd>LazyFormatInfo<cr>", { desc = "Format Info" })

-- VSCode-like literal search.
-- `/` and `?` default to "very nomagic" (\V) so characters like . * [ ] ( )
-- match literally instead of as regex -- just like VSCode's default search.
-- Empty search still repeats the last one (verified). To use regex for a search,
-- prefix the pattern with \v, e.g.  /\vfoo|bar  . `*`/`#` (word search) are
-- left as-is.
keymap.set({ "n", "x", "o" }, "/", "/\\V", { desc = "Search (literal)" })
keymap.set({ "n", "x", "o" }, "?", "?\\V", { desc = "Search backward (literal)" })

vim.g.ai_commit_provider = "nvim"

vim.api.nvim_create_user_command("AICommit", function()
  vim.fn.jobstart({ "ai-commit", "--provider", vim.g.ai_commit_provider, "--json" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local output = table.concat(data, "\n")
      if output == "" then
        return
      end

      local ok, result = pcall(vim.json.decode, output)
      if ok and result.message then
        vim.fn.setreg("+", result.message)
        vim.notify("AI commit message copied")
      end
    end,
    on_stderr = function(_, data)
      local message = table.concat(data, "\n")
      if message ~= "" then
        vim.notify(message, vim.log.levels.ERROR)
      end
    end,
  })
end, {})
