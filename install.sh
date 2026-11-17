cat << 'EOF' > ~/dotfiles/install.sh
#!/usr/bin/env bash
set -e

# Install Starship if it isn't already installed
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs | sh -s -- -y
fi

# Add Starship init to .bashrc (avoiding duplicates)
if ! grep -q "starship init bash" ~/.bashrc; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

# Link custom Starship config if it exists in the dotfiles repo
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$DOTFILES_DIR/starship.toml" ]; then
    mkdir -p ~/.config
    ln -sf "$DOTFILES_DIR/starship.toml" ~/.config/starship.toml
fi
EOF
