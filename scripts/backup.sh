#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

backup() {
  local src="$1"
  local dest="$2"
  if [[ -e "$src" && ! -L "$src" ]]; then
    mkdir -p "$(dirname "$BACKUP_DIR/$dest")"
    cp -r "$src" "$BACKUP_DIR/$dest"
    echo "  backed up $src"
  fi
}

echo "Backing up to $BACKUP_DIR..."

backup "$HOME/.zshrc"                        ".zshrc"
backup "$HOME/.zprofile"                     ".zprofile"
backup "$HOME/.ssh/config"                   ".ssh/config"
backup "$HOME/.config/git/config"            ".config/git/config"
backup "$HOME/.config/ghostty/config"        ".config/ghostty/config"
backup "$HOME/.config/ghostty/themes"        ".config/ghostty/themes"
backup "$HOME/.config/gh/config.yml"         ".config/gh/config.yml"
backup "$HOME/.config/opencode/opencode.json" ".config/opencode/opencode.json"
backup "$HOME/.config/opencode/package.json" ".config/opencode/package.json"
backup "$HOME/.config/opencode/bun.lock"     ".config/opencode/bun.lock"
backup "$HOME/.config/opencode/skills"       ".config/opencode/skills"

if [[ "$(uname)" == "Darwin" ]]; then
  VSCODE_DIR="$HOME/Library/Application Support/Code/User"
else
  VSCODE_DIR="$HOME/.config/Code/User"
fi
backup "$VSCODE_DIR/settings.json"    "vscode/settings.json"
backup "$VSCODE_DIR/keybindings.json" "vscode/keybindings.json"

echo "Done. Backup saved to $BACKUP_DIR"
