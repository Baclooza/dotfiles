#!/usr/bin/env bash
# Dotfiles install script for dev containers: installs and activates Starship.
set -eo pipefail

# Preset used when the repo has no starship.toml of its own.
# "plain-text-symbols" needs no special font. Set to "" for Starship's default
# look, which needs a Nerd Font on the host.
STARSHIP_PRESET="plain-text-symbols"

# 1. Install Starship if it is not already present (the Feature may have done it)
if ! command -v starship >/dev/null 2>&1; then
    SUDO=""
    CAN_INSTALL=1
    if [ "$(id -u)" -ne 0 ]; then
        if command -v sudo >/dev/null 2>&1; then
            SUDO="sudo"
        else
            echo "Not root and no sudo; skipping Starship install."
            CAN_INSTALL=0
        fi
    fi
    if [ "$CAN_INSTALL" -eq 1 ]; then
        if command -v curl >/dev/null 2>&1; then
            curl -fsS https://starship.rs/install.sh | $SUDO sh -s -- -y
        elif command -v wget >/dev/null 2>&1; then
            wget -qO- https://starship.rs/install.sh | $SUDO sh -s -- -y
        else
            echo "Neither curl nor wget found; skipping Starship install."
        fi
    fi
fi

# Without Starship there is nothing to set up
if ! command -v starship >/dev/null 2>&1; then
    echo "Starship is not available; skipping prompt setup."
    exit 0
fi

# 2. Turn Starship on in bash (no duplicate lines)
touch ~/.bashrc
if ! grep -q "starship init bash" ~/.bashrc; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

# 3. Config: use the repo's starship.toml if there is one, otherwise a preset
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p ~/.config
if [ -f "$DOTFILES_DIR/starship.toml" ]; then
    ln -sf "$DOTFILES_DIR/starship.toml" ~/.config/starship.toml
elif [ -n "$STARSHIP_PRESET" ] && [ ! -e ~/.config/starship.toml ]; then
    starship preset "$STARSHIP_PRESET" -o ~/.config/starship.toml
fi