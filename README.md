# My dotfiles

This directory contains my dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Works on both macOS and Linux.

## What's managed

| Config | Path |
|--------|------|
| Zsh | `~/.zshrc`, `~/.zprofile` |
| SSH | `~/.ssh/config` |
| Git | `~/.config/git/config` |
| Ghostty | `~/.config/ghostty/` |
| GitHub CLI | `~/.config/gh/config.yml` |
| Claude Code | `~/.claude/settings.json`, `CLAUDE.md`, `commands/`, `skills/` |
| opencode | `~/.config/opencode/opencode.json`, `skills/`, `package.json` |
| VS Code | `~/Library/Application Support/Code/User/` (macOS) or `~/.config/Code/User/` (Linux) |

## Requirements

- **GNU Stow** — for managing symlinks
- **Git >= 2.23** — required by git aliases (`switch`, `defaultBranch`)
- **zsh** — shell configuration
- **oh-my-zsh** + **Zinit** — run `./scripts/setup-zsh.sh` to install

## Installation

```sh
git clone https://github.com/lucasamonrc/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Back up existing dotfiles before overwriting them
./scripts/backup.sh

# Install zsh dependencies (oh-my-zsh, spaceship theme, zinit)
./scripts/setup-zsh.sh

# Symlink all dotfiles
stow .

# Symlink VS Code settings (handles macOS/Linux path differences)
./scripts/setup-vscode.sh
```

## Notes

- **SSH keys** are not managed here — only `~/.ssh/config`
- **`~/.config/gh/hosts.yml`** is excluded (contains OAuth tokens)
- **`~/.claude/settings.local.json`** is excluded (machine-specific)
- Run `./scripts/backup.sh` any time to snapshot current dotfiles to a timestamped directory in `~`; only real files are copied (symlinks are skipped)
