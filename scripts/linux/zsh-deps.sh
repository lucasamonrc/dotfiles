#!/usr/bin/env bash
set -Eeuo pipefail

zsh_dir="${ZSH_DEPS_DIR:-"$HOME/.zsh"}"

command -v git >/dev/null 2>&1 || {
    echo "Error: git is required." >&2
    exit 1
}

mkdir -p "$zsh_dir"

clone_if_missing() {
    local url="$1"
    local destination="$2"

    if [[ -e "$destination" ]]; then
        if git -C "$destination" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            echo "Already installed: $destination"
        else
            echo "Error: $destination exists but is not a Git repository." >&2
            exit 1
        fi
        return
    fi

    echo "Cloning: $destination"
    git clone --depth=1 "$url" "$destination"
}

clone_if_missing \
    "https://github.com/spaceship-prompt/spaceship-prompt.git" \
    "$zsh_dir/spaceship"

clone_if_missing \
    "https://github.com/zsh-users/zsh-completions.git" \
    "$zsh_dir/zsh-completions"

clone_if_missing \
    "https://github.com/zsh-users/zsh-autosuggestions.git" \
    "$zsh_dir/zsh-autosuggestions"

clone_if_missing \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
    "$zsh_dir/zsh-syntax-highlighting"

echo "Zsh dependencies are ready."
