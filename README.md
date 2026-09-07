# Profile

Personal, opinionated configuration files for my daily development environment — [Zed](https://zed.dev), [VS Code](https://code.visualstudio.com), [Trae](https://www.trae.ai), and [Neovim](https://neovim.io) (powered by [LazyVim](https://github.com/LazyVim/LazyVim)) — plus shared code snippets and formatter defaults. Keeping everything in one repository makes the setup reviewable, versioned, and easy to replicate on a new machine.

## Highlights

- **Maple Mono NF** as the typeface for editors and terminals (Nerd Font glyph support)
- **Tokyo Night** light/dark themes that follow the macOS system appearance automatically
- **Vim mode** in Zed and a Vim-first workflow in Neovim
- **Prettier style**: no semicolons, single quotes — consistently configured in `.prettierrc`, Zed, and VS Code
- **Fix-on-save** chains (Prettier → ESLint → organize imports) for TypeScript/JavaScript in Zed
- **Material Icon Theme** across supported editors
- **One-command setup** — [`install.sh`](install.sh) deploys the whole collection to a new machine and snapshots anything it replaces
- Vue/Vite-oriented extras (profiles, snippets, debug launchers)

## Repository layout

| Path | Configures |
| --- | --- |
| [`nvim/`](nvim) | Neovim (LazyVim distribution): plugins, keymaps, autocmds, color schemes, statusline themes |
| [`vscode/`](vscode) | VS Code user settings, extension list + installer, profiles, Chrome debug launchers |
| [`zed/`](zed) | Zed settings, keymap, and vim-mode bindings |
| [`trae/`](trae) | Trae (AI IDE) settings |
| [`install.sh`](install.sh), [`install.ps1`](install.ps1) | One-shot installers for macOS/Linux and Windows (with automatic backups) |
| [`snippets/`](snippets) | Code snippets (Vue SFC scaffold, console.log) |
| [`.prettierrc`](.prettierrc), [`.prettierignore`](.prettierignore) | Shared formatting defaults |
| [`package.json`](package.json), [`.gitignore`](.gitignore), [`LICENSE`](LICENSE) | Project metadata, ignores, MIT license |

## One-click setup (new machine)

Clone the repo and run the installer for your platform — no manual copying:

```bash
git clone <repo-url> profile
cd profile
./install.sh            # full install
./install.sh --dry-run  # preview what would change first (writes nothing)
```

On Windows, run PowerShell from the repository directory:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1                 # full install
.\install.ps1 -DryRun         # preview what would change first
```

The Windows installer uses a directory junction for Neovim when supported and
falls back to a copied directory otherwise. It targets `%LOCALAPPDATA%` and
`%APPDATA%` by default; the same section switches and environment overrides
listed below are available in PowerShell form (`-Nvim`, `-Zed`, `-Vscode`,
`-Trae`, `-Prettier`, `-All`, `-NoBackup`, and `-NoExtensions`).

What each section does:

| Section | Installs | Destination (macOS) |
| --- | --- | --- |
| `nvim` | whole config dir — **symlinked**, so the repo stays the source of truth | `~/.config/nvim` |
| `zed` | `settings.json`, `keymap.json` | `~/.config/zed/` |
| `vscode` | `settings.json` + snippets; installs the `plugins.json` extensions via the `code` CLI | `~/Library/Application Support/Code/User/` |
| `trae` | `settings.json` + snippets | `~/Library/Application Support/Trae/User/` |
| `--prettier` | `.prettierrc`, `.prettierignore` (opt-in) | `$HOME` |

The Windows destinations are `%LOCALAPPDATA%\nvim`, `%APPDATA%\Zed`,
`%APPDATA%\Code\User`, and `%APPDATA%\Trae\User`.

Safety and controls:

- Anything already present is snapshotted to `~/.config-backup/<timestamp>/` before being replaced — delete that folder once you're happy.
- With `--no-backup` the script refuses to remove an existing directory, so it can't silently destroy configs.
- Flags: `--all`, `--nvim`, `--zed`, `--vscode`, `--trae`, `--prettier`, `--no-extensions`, `-n/--dry-run`, `-h/--help`.
- Destinations are overridable via `NVIM_DIR`, `ZED_DIR`, `VSCODE_USER_DIR`, `TRAE_USER_DIR`.
- On Linux the VS Code/Trae dirs default to `~/.config/Code/User` and `~/.config/Trae/User`.

After installing: run `nvim` once (lazy.nvim bootstraps and pulls all plugins), import the VS Code profiles via the Command Palette (`Profiles: Import Profile`), then restart your editors.

## Usage

### Neovim

LazyVim-based config. `lua/config/lazy.lua` bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim) automatically, imports the LazyVim spec, then your custom `lua/plugins/*` overrides.

```bash
# macOS: point your config at this repo
ln -s "$(pwd)/nvim" ~/.config/nvim
nvim  # first launch installs all plugins
```

Contents:

- `lua/plugins/` — LSP, formatting, treesitter, git, snacks, dashboard, and colorscheme setups
- `lua/config/` — keymaps, options, autocmds, lazy.nvim bootstrap
- `lua/util/` — helper modules (macOS system-theme detection, Vite+ project detection, persistent oxfmt LSP client for fast format-on-save)
- `colors/` — custom palettes (`vitesse-black`, `vitesse-light-soft`)
- `lua/lualine/themes/` — statusline theme overrides

### Zed

```bash
cp zed/settings.json zed/keymap.json ~/.config/zed/
```

Highlights: vim mode with space-prefixed bindings for files/panels/git (e.g. `space f f`, `space g g`), `ctrl-h/j/k/l` pane navigation, Prettier formatting with `format_on_save`, Copilot agent (default model `gpt-5-mini`), Tokyo Night Light / GitHub Dark Default themes, and Material Icon Theme.

### VS Code

- **Settings** — copy `vscode/settings.json` into your user settings:
  ```bash
  cp vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
  ```
- **Profiles** — import `vscode/profiles/*.code-profile` via the Command Palette (`Profiles: Import Profile`). The `node` profile targets Node/TypeScript work; two files (`vue-profile.code-profile` and `plugins.code-profile`) are both exported under the internal name `vue-profile` for Vue development — import only one of them to avoid an overwrite prompt.
- **Extensions** — the list lives in `vscode/plugins.json` (Volar, UnoCSS, Prettier, ESLint, rust-analyzer, …). `./install.sh` installs them automatically when the `code` CLI is on `PATH`; the helper script itself expects the list at `ext.json`, so wire it up first when running it by hand:
  ```bash
  cd vscode && cp plugins.json ext.json && node install-extensions.js
  ```
- **Debugging** — `vscode/debug/` ships Chrome launchers (`launch.json` targets a Canary build with CORS disabled and source-map overrides; `attach.json` attaches to a running browser).

### Trae

`trae/settings.json` mirrors the VS Code user settings. Copy it into Trae's settings location (same conventions as VS Code) to get identical editor, Git, and theming behavior.

### Snippets

Drop `snippets/*.json` into your editor's user-snippets directory:

- `vue.json` — Vue 3 `<script setup>` + `<template>` + `<style>` SFC scaffold (prefix `vue`)
- `csl.json` — `console.log` shortcut (prefix `csl`; JS/TS/Vue scopes)

### Shared formatting

`.prettierrc` (no semicolons, single quotes) is the project-wide default used by Prettier in any editor or CLI:

```bash
npx --yes prettier --write .
```

## Requirements

- [Maple Mono NF](https://github.com/subframe7536/maple-font) installed for the configured font stacks (otherwise, update font settings per editor)
- VS Code profiles expect the extensions listed in `vscode/plugins.json` to be installed
- Neovim config requires a recent stable Neovim build (per [LazyVim requirements](https://lazyvim.github.io/installation)) and a Nerd Font for statusline glyphs

## License

MIT © [Carl Chen](LICENSE)

---

> These settings are personal and opinionated — fork what you like, but expect them tuned to macOS + Vue/TypeScript development.
