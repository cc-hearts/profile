# ⚙️ Profile

Personal, opinionated configuration files for my daily development environment — [Zed](https://zed.dev), [VS Code](https://code.visualstudio.com), [Trae](https://www.trae.ai), and [Neovim](https://neovim.io) (powered by [LazyVim](https://github.com/LazyVim/LazyVim)) — plus shared code snippets and formatter defaults. The repository is designed to be reviewable, versioned, and easy to replicate on a new machine.

## Highlights

- **Maple Mono NF** as the typeface for editors and terminals (Nerd Font glyph support)
- **Tokyo Night** light/dark themes that follow the macOS system appearance automatically
- **Vim mode** in Zed and a Vim-first workflow in Neovim
- **Prettier style**: no semicolons, single quotes — consistently configured in `.prettierrc`, Zed, and VS Code
- **Fix-on-save** chains (Prettier → ESLint → organize imports) for TypeScript/JavaScript in Zed
- **Material Icon Theme** across supported editors
- **One-command setup** with automatic backups for replaced configuration
- Vue/Vite-oriented profiles, snippets, and debug launchers

## Repository layout

| Path | Configures |
| --- | --- |
| [`nvim/`](nvim) | Neovim (LazyVim): plugins, keymaps, autocmds, color schemes, statusline themes |
| [`vscode/`](vscode) | VS Code settings, extension list + installer, profiles, Chrome debug launchers |
| [`zed/`](zed) | Zed settings, keymap, and Vim-mode bindings |
| [`trae/`](trae) | Trae (AI IDE) settings |
| [`install.sh`](install.sh), [`install.ps1`](install.ps1) | One-shot installers for macOS/Linux and Windows, with automatic backups |
| [`snippets/`](snippets) | Shared snippets (Vue SFC scaffold, `console.log`) |
| [`.prettierrc`](.prettierrc), [`.prettierignore`](.prettierignore) | Shared formatting defaults |
| [`package.json`](package.json), [`.gitignore`](.gitignore), [`LICENSE`](LICENSE) | Project metadata, ignores, and MIT license |

## One-click setup

Clone the repository and run the installer for your platform:

```bash
git clone <repo-url> profile
cd profile
./install.sh            # full install
./install.sh --dry-run  # preview changes without writing
```

On Windows, run PowerShell from the repository directory:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1                 # full install
.\install.ps1 -DryRun         # preview changes without writing
```

The Windows installer uses a directory junction for Neovim when supported and falls back to a copied directory otherwise. It targets `%LOCALAPPDATA%` and `%APPDATA%` by default; PowerShell exposes the same section switches and environment overrides as the shell installer (`-Nvim`, `-Zed`, `-Vscode`, `-Trae`, `-Prettier`, `-All`, `-NoBackup`, and `-NoExtensions`).

What each section does:

| Section | Installs | Destination (macOS) |
| --- | --- | --- |
| `nvim` | Whole config directory — **symlinked**, so the repo stays the source of truth | `~/.config/nvim` |
| `zed` | `settings.json`, `keymap.json` | `~/.config/zed/` |
| `vscode` | `settings.json`, snippets, and optional extensions | `~/Library/Application Support/Code/User/` |
| `trae` | `settings.json` and snippets | `~/Library/Application Support/Trae/User/` |
| `--prettier` | `.prettierrc`, `.prettierignore` (opt-in) | `$HOME` |

The Windows destinations are `%LOCALAPPDATA%\nvim`, `%APPDATA%\Zed`, `%APPDATA%\Code\User`, and `%APPDATA%\Trae\User`.

Safety and controls:

- Existing files are snapshotted to `~/.config-backup/<timestamp>/` before replacement.
- With `--no-backup`, the installer refuses to remove an existing directory.
- Flags: `--all`, `--nvim`, `--zed`, `--vscode`, `--trae`, `--prettier`, `--no-extensions`, `-n/--dry-run`, `-h/--help`.
- Destinations can be overridden with `NVIM_DIR`, `ZED_DIR`, `VSCODE_USER_DIR`, and `TRAE_USER_DIR`.
- Linux defaults VS Code and Trae to `~/.config/Code/User` and `~/.config/Trae/User`.

After installing, run `nvim` once so lazy.nvim can bootstrap and install plugins, import VS Code profiles via the Command Palette (`Profiles: Import Profile`), then restart your editors.

## Editor configuration

### Neovim

LazyVim-based configuration with Lua plugin setup, custom color schemes, StyLua formatting, and a [Git merge cheat sheet](nvim/git-merge-cheatsheet.md). `lua/config/lazy.lua` bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim), imports the LazyVim spec, and then loads the custom `lua/plugins/*` overrides.

```bash
# Point Neovim at this repository on macOS/Linux
ln -s "$(pwd)/nvim" ~/.config/nvim
nvim  # first launch installs all plugins
```

Key directories:

- `lua/plugins/` — LSP, formatting, treesitter, Git, snacks, dashboard, and colorscheme setup
- `lua/config/` — keymaps, options, autocmds, and lazy.nvim bootstrap
- `lua/util/` — macOS theme detection, Vite+ project detection, and formatting helpers
- `colors/` — custom palettes (`vitesse-black`, `vitesse-light-soft`)
- `lua/lualine/themes/` — statusline theme overrides

### VS Code

| File | Description |
| --- | --- |
| `settings.json` | Editor settings |
| `plugins.json` | Recommended extensions |
| `install-extensions.js` | One-command extension installer |
| `profiles/` | Importable profiles |
| `debug/` | Browser debugging configurations |

Common extensions include Volar, UnoCSS, Prettier, ESLint, Error Lens, Git Graph, and rust-analyzer. The installer reads `vscode/plugins.json` and installs extensions automatically when the `code` CLI is available.

To run the helper manually:

```bash
cd vscode && cp plugins.json ext.json && node install-extensions.js
```

Import `vscode/profiles/*.code-profile` through `Profiles: Import Profile`. The Node profile targets Node/TypeScript work; import only one of the two Vue profile exports to avoid an overwrite prompt.

### Trae

`trae/settings.json` mirrors the VS Code settings and additionally enables `AI.toolcall.confirmMode: autoRun`. Copy it into Trae's user settings location to share the same editor, Git, and theming behavior.

### Zed

Zed uses Vim mode with space-prefixed bindings for files, panels, and Git, `ctrl-h/j/k/l` pane navigation, Prettier `format_on_save`, Copilot agent support, Tokyo Night Light / GitHub Dark Default themes, and Material Icon Theme.

```bash
cp zed/settings.json zed/keymap.json ~/.config/zed/
```

## Snippets and formatting

| File | Prefix | Description |
| --- | --- | --- |
| `snippets/csl.json` | `csl` | Quick `console.log()` snippet |
| `snippets/vue.json` | `vue` | Vue 3 SFC scaffold (`<script setup>` + `<template>` + `<style>`) |

`.prettierrc` is the shared project default: no semicolons and single quotes.

```bash
npx --yes prettier --write .
```

## Preferences

| Item | Configuration |
| --- | --- |
| Font | Maple Mono NF |
| Dark theme | Tokyo Night Storm / GitHub Dark |
| Light theme | Tokyo Night Light |
| Icon theme | Material Icon Theme |
| Indentation | 2 spaces |
| Formatting | Prettier (no semicolons, single quotes) |
| Auto-save | 5-second delay where supported |

## Requirements

- [Maple Mono NF](https://github.com/subframe7536/maple-font) installed for the configured font stacks
- VS Code profiles' extensions installed from `vscode/plugins.json`
- A recent stable Neovim build meeting [LazyVim requirements](https://lazyvim.github.io/installation)
- A Nerd Font for Neovim statusline glyphs

## License

MIT © [Carl Chen](LICENSE)

---

> These settings are personal and opinionated — fork what you like, but expect them tuned to macOS + Vue/TypeScript development.
