# Lucas's dotfiles

Personal shell and developer-environment configuration for Linux/WSL and Windows.

This repository keeps shared configuration in one place while allowing each operating system to have its own setup:

- **Common** — configuration shared between Linux and Windows.
- **Linux** — Zsh and GNU Stow-managed files.
- **Windows** — PowerShell, Starship, and Windows Terminal configuration.
- **Scripts** — repeatable setup scripts.

## Repository layout

```text
common/
└── stow/
    ├── git/
    │   └── .config/git/config
    └── herdr/
        └── .config/herdr/config.toml

linux/
└── stow/
    └── home/
        └── .zshrc

scripts/
├── linux/
│   └── zsh-deps.sh
└── windows/
    └── install-dotfiles.sh

windows/
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1
├── starship/
│   └── starship.toml
└── terminal/
    └── settings.json
```

## Linux / WSL setup

Prerequisites: Git, Zsh, and GNU Stow.

```bash
mkdir -p ~/Projects/Linux
git clone https://github.com/lucasamonrc/dotfiles.git ~/Projects/Linux/dotfiles
cd ~/Projects/Linux/dotfiles

./scripts/linux/zsh-deps.sh
```

The dependency script installs Spaceship, zsh-completions, zsh-autosuggestions, and zsh-syntax-highlighting.

It is safe to run repeatedly. Existing Git repositories are left untouched; an existing non-Git directory causes the script to stop instead of overwriting it.

Apply the Linux Stow package:

```bash
stow --dir linux/stow --target "$HOME" home
```

Apply shared Git and Herdr configuration:

```bash
stow --dir common/stow --target "$HOME" git herdr
```

If Stow reports a conflict, inspect the existing file before replacing it or using `--adopt`.

## Windows setup

```powershell
git clone https://github.com/lucasamonrc/dotfiles.git "$HOME\Projects\dotfiles"
cd "$HOME\Projects\dotfiles"
pwsh -File .\scripts\windows\install-dotfiles.sh
```

The Windows installer copies common and Windows-specific files into their expected locations and creates timestamped backups when a destination already exists.

The installer is PowerShell code and currently has a `.sh` filename.

| Repository file | Windows destination |
| --- | --- |
| `common/stow/git/.config/git/config` | `$HOME\.config\git\config` |
| `common/stow/herdr/.config/herdr/config.toml` | `$HOME\.config\herdr\config.toml` |
| `windows/starship/starship.toml` | `$HOME\.config\starship.toml` |
| `windows/powershell/Microsoft.PowerShell_profile.ps1` | `$HOME\.config\powershell\Microsoft.PowerShell_profile.ps1` |

Windows Terminal settings are tracked at `windows/terminal/settings.json`. Review machine-specific paths and profiles before copying them into Windows Terminal's LocalState directory.

## Updating the configuration

After changing a configuration file:

```bash
git status
git diff
git add .
git commit -m "Update dotfiles"
git push
```

On another machine, pull the changes and rerun the appropriate setup command or installer.

## Notes

- Keep credentials, tokens, and machine-specific secrets out of this repository.
- Shared configuration should work on both operating systems; keep OS-specific paths and tools in the Linux or Windows directories.
- Backups created by the Windows installer use the format `*.bak-YYYYMMDD-HHMMSS`. Remove them only after verifying the new configuration.

