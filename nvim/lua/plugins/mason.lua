return {
  { "mason-org/mason.nvim", version = "1.11.0",
  opts = {
    ensure_installed = {
      "stylua",
      "shellcheck",
      "shfmt",
      "flake8",
    },
  },
},
  { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
}