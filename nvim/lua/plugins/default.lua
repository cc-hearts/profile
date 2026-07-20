-- Disable LazyVim's bundled colorschemes we don't use.
-- We use the local `vitesse-black` theme (see colors/vitesse-black.lua),
-- so catppuccin / tokyonight are dead weight.
return {
  { "catppuccin", enabled = false },
  { "tokyonight.nvim", enabled = false },
}
