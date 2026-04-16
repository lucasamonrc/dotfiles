#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
  VSCODE_DIR="$HOME/Library/Application Support/Code/User"
else
  VSCODE_DIR="$HOME/.config/Code/User"
fi

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)/vscode"

mkdir -p "$VSCODE_DIR"

for file in settings.json keybindings.json; do
  if [[ -f "$VSCODE_DIR/$file" && ! -L "$VSCODE_DIR/$file" ]]; then
    echo "Backing up existing $file..."
    cp "$VSCODE_DIR/$file" "$VSCODE_DIR/$file.bak"
  fi
  rm -f "$VSCODE_DIR/$file"
  ln -sf "$REPO_DIR/$file" "$VSCODE_DIR/$file"
  echo "Linked $file"
done
