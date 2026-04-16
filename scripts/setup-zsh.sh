#!/bin/zsh
set -e

cd $HOME

echo "🚀 Setting up zsh..."

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "  Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
echo "✅ oh-my-zsh is installed!"                                        

# Spaceship theme
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
    echo "  Cloning spaceship-prompt..."
    git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
fi
if [ ! -L "$ZSH_CUSTOM/themes/spaceship.zsh-theme" ]; then
    echo "  Creating spaceship theme symlink..."
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi
echo "✅ spaceship theme is installed!"

# Zinit
if [ ! -d "$HOME/.local/share/zinit" ]; then
    echo "  Installing zinit..."
    sh -c "$(curl -fsSL https://git.io/zinit-install)"
fi
echo "✅ zinit is installed!"
