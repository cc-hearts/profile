#!/usr/bin/env bash
#
# install.sh — one-shot deployment of this repository's configuration
# collection onto a (new) machine. New-machine setup is then one command:
#
#     ./install.sh                # install everything (with backups)
#     ./install.sh --dry-run      # preview what would change, write nothing
#     ./install.sh --zed --trae   # only the selected sections
#
# Every destination is snapshotted into $BACKUP_ROOT before it is replaced
# (default: ~/.config-backup/<timestamp>/), so the install is reversible.
#
# Section targets (each can be overridden with the matching env variable):
#   nvim     -> $NVIM_DIR         (~/.config/nvim, symlinked to this repo)
#   zed      -> $ZED_DIR          (~/.config/zed)
#   vscode   -> $VSCODE_USER_DIR  (~/Library/Application Support/Code/User on macOS)
#   trae     -> $TRAE_USER_DIR    (~/Library/Application Support/Trae/User on macOS)
#   prettier -> ~/.prettierrc, ~/.prettierignore   (opt-in: --prettier / --all)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS_NAME="$(uname -s)"

# --- default destinations -------------------------------------------------
NVIM_DIR="${NVIM_DIR:-$HOME/.config/nvim}"
ZED_DIR="${ZED_DIR:-$HOME/.config/zed}"
if [[ "$OS_NAME" == "Darwin" ]]; then
  VSCODE_USER_DIR="${VSCODE_USER_DIR:-$HOME/Library/Application Support/Code/User}"
  TRAE_USER_DIR="${TRAE_USER_DIR:-$HOME/Library/Application Support/Trae/User}"
else
  VSCODE_USER_DIR="${VSCODE_USER_DIR:-$HOME/.config/Code/User}"
  TRAE_USER_DIR="${TRAE_USER_DIR:-$HOME/.config/Trae/User}"
fi
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.config-backup}"
BACKUP_TS="$(date +%Y%m%d-%H%M%S)"

DO_BACKUP=1
DO_EXT=1
DRY_RUN=0
SELECT=()

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Deploy this repository's editor configurations to this machine.
By default every section below is installed (except --prettier).
Existing files are snapshotted to ~/.config-backup/<timestamp>/ first.

Options:
  --all               install every section, including home Prettier files
  --nvim              Neovim config        -> ~/.config/nvim          (symlink)
  --zed               Zed settings/keymap  -> ~/.config/zed
  --vscode            VS Code settings + snippets, install extensions (via 'code')
  --trae              Trae settings + snippets
  --prettier          copy .prettierrc/.prettierignore to $HOME
  --no-extensions     skip the VS Code extension install step
  --no-backup         replace existing files without snapshots (risky)
  -n, --dry-run       show what would change, write nothing
  -h, --help          show this help

Environment overrides (defaults shown above): NVIM_DIR, ZED_DIR,
VSCODE_USER_DIR, TRAE_USER_DIR, BACKUP_ROOT
EOF
}

log()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m  +\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m  !\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mFAIL\033[0m %s\n' "$*" >&2; exit 1; }

has() { [[ " ${SELECT[*]} " == *" $1 "* ]]; }

backup_if_exists() {
  local src="$1" rel dst
  [[ -e "$src" || -L "$src" ]] || return 0
  if [[ "$src" == "$HOME"/* ]]; then
    rel="${src#"$HOME"/}"
  else
    rel="$(basename "$src")"
  fi
  dst="$BACKUP_ROOT/$BACKUP_TS/$rel"
  if [[ "$DRY_RUN" == 1 ]]; then
    ok "would back up $src -> $dst"
  elif [[ "$DO_BACKUP" == 1 ]]; then
    mkdir -p "$(dirname "$dst")"
    cp -R "$src" "$dst"
    ok "backed up $src -> $dst"
  fi
}

install_file() {
  local src="$1" dst="$2"
  backup_if_exists "$dst"
  if [[ "$DRY_RUN" == 1 ]]; then
    ok "would copy $src -> $dst"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  ok "installed $dst"
}

# Symlink $1 at $2. If $2 is a real directory it is replaced only after a
# successful backup; --no-backup refuses to delete an existing directory.
install_link() {
  local src="$1" dst="$2"
  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ -d "$dst" && ! -L "$dst" ]]; then
      if [[ "$DO_BACKUP" != 1 ]]; then
        die "refusing to replace existing directory $dst without a backup (drop --no-backup)"
      fi
      backup_if_exists "$dst"
      if [[ "$DRY_RUN" == 1 ]]; then
        ok "would symlink $src -> $dst"
        return
      fi
      rm -rf "$dst"
    else
      backup_if_exists "$dst"
      if [[ "$DRY_RUN" == 1 ]]; then
        ok "would symlink $src -> $dst"
        return
      fi
      rm -f "$dst"
    fi
  elif [[ "$DRY_RUN" == 1 ]]; then
    ok "would symlink $src -> $dst"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  ok "linked $dst -> $src"
}

install_vscode_extensions() {
  if [[ "$DO_EXT" != 1 ]]; then
    return 0
  fi
  if [[ "$DRY_RUN" == 1 ]]; then
    ok "would install extensions listed in vscode/plugins.json via 'code'"
    return 0
  fi
  if ! command -v code >/dev/null 2>&1; then
    warn "no 'code' CLI in PATH — skipped extension install (run it later: ./install.sh)"
    return 0
  fi
  local tmp
  tmp="$(mktemp -d)"
  # install-extensions.js reads ./ext.json from its working directory.
  cp "$REPO_DIR/vscode/plugins.json" "$tmp/ext.json"
  if (cd "$tmp" && node "$REPO_DIR/vscode/install-extensions.js"); then
    ok "installed extensions from vscode/plugins.json"
  else
    warn "extension install reported an error — check 'code --list-extensions'"
  fi
  rm -rf "$tmp"
}

section_nvim() {
  log "Neovim -> $NVIM_DIR"
  install_link "$REPO_DIR/nvim" "$NVIM_DIR"
}

section_zed() {
  log "Zed -> $ZED_DIR"
  install_file "$REPO_DIR/zed/settings.json" "$ZED_DIR/settings.json"
  install_file "$REPO_DIR/zed/keymap.json" "$ZED_DIR/keymap.json"
}

section_vscode() {
  log "VS Code -> $VSCODE_USER_DIR"
  install_file "$REPO_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
  install_file "$REPO_DIR/snippets/vue.json" "$VSCODE_USER_DIR/snippets/vue.json"
  install_file "$REPO_DIR/snippets/csl.json" "$VSCODE_USER_DIR/snippets/csl.json"
  install_vscode_extensions
  if [[ "$DRY_RUN" != 1 ]]; then
    printf '       profiles: import vscode/profiles/*.code-profile via\n'
    printf '       Command Palette -> "Profiles: Import Profile"\n'
  fi
}

section_trae() {
  log "Trae -> $TRAE_USER_DIR"
  install_file "$REPO_DIR/trae/settings.json" "$TRAE_USER_DIR/settings.json"
  install_file "$REPO_DIR/snippets/vue.json" "$TRAE_USER_DIR/snippets/vue.json"
  install_file "$REPO_DIR/snippets/csl.json" "$TRAE_USER_DIR/snippets/csl.json"
}

section_prettier() {
  log "Prettier home defaults -> $HOME"
  install_file "$REPO_DIR/.prettierrc" "$HOME/.prettierrc"
  install_file "$REPO_DIR/.prettierignore" "$HOME/.prettierignore"
}

main() {
  local arg
  for arg in "$@"; do
    case "$arg" in
      -h|--help) usage; exit 0 ;;
      -n|--dry-run) DRY_RUN=1 ;;
      --no-backup) DO_BACKUP=0 ;;
      --no-extensions) DO_EXT=0 ;;
      --all) SELECT=(nvim zed vscode trae prettier) ;;
      --nvim|--zed|--vscode|--trae|--prettier) SELECT+=("${arg#--}") ;;
      *) die "unknown option: $arg (see --help)" ;;
    esac
  done
  [[ ${#SELECT[@]} -gt 0 ]] || SELECT=(nvim zed vscode trae)

  log "Profile installer (repo: $REPO_DIR)"
  [[ "$DRY_RUN" == 1 ]] && warn "dry run — nothing will be written"

  has nvim     && section_nvim
  has zed      && section_zed
  has vscode   && section_vscode
  has trae     && section_trae
  has prettier && section_prettier

  echo
  log "Done."
  if [[ "$DRY_RUN" == 1 ]]; then
    warn "dry run — nothing was written. Re-run without --dry-run to apply."
  else
    printf '  - nvim: run `nvim` once — lazy.nvim bootstraps and installs all plugins\n'
    printf '  - VS Code: import profiles via Command Palette -> "Profiles: Import Profile"\n'
    printf '  - Restart Zed / VS Code / Trae so the new settings take effect\n'
    if [[ "$DO_BACKUP" == 1 ]]; then
      printf '  - Previous files are kept under %s\n' "$BACKUP_ROOT/$BACKUP_TS"
    fi
  fi
}

main "$@"
