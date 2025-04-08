return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "unocss-language-server",
        "shellcheck",
        "shfmt",
        "gitui",
        "flake8",
      },
    },
  },
}
