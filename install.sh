#!/usr/bin/env bash
set -e

# 1. Install Starship if not already present
if ! command -v starship &> /dev/null; then
    if command -v curl &> /dev/null; then
        curl -sS https://starship.rs | sh -s -- -y
    elif command -v wget &> /dev/null; then
        wget -qO- https://starship.rs | sh -s -- -y
    else
        echo "Neither curl nor wget found; skipping Starship install."
        exit 0
    fi
fi

# 2. Initialize Starship in ~/.bashrc (avoiding duplicate lines)
if [ -f ~/.bashrc ] && ! grep -q "starship init bash" ~/.bashrc; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

# 3. Link custom starship.toml if one exists in this repo
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
if [ -f "$DOTFILES_DIR/starship.toml" ]; then
    mkdir -p ~/.config
    ln -sf "$DOTFILES_DIR/starship.toml" ~/.config/starship.toml
fi