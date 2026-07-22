-- Light Soft entry point for the shared Vitesse theme implementation.
vim.g.vitesse_theme_variant = "light-soft"
local ok, err = pcall(vim.cmd, "runtime colors/vitesse-black.lua")
vim.g.vitesse_theme_variant = nil
if not ok then
  error(err)
end
