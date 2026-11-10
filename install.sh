#!/bin/bash
set -e

echo "🚀 Installing Starship Prompt..."

# 1. Install the Starship binary to a user-writable directory (~/.local/bin)
mkdir -p "$HOME/.local/bin"
curl -sS https://starship.rs | sh -s -- --bin-dir "$HOME/.local/bin" -y

# 2. Add ~/.local/bin to PATH if it isn't already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# 3. Inject Starship initialization into shell profiles if not already present
# For Bash
if [ -f "$HOME/.bashrc" ] && ! grep -q 'starship init bash' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
fi

# For Zsh (in case the dev container uses it)
if [ -f "$HOME/.zshrc" ] && ! grep -q 'starship init zsh' "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
fi

echo "✅ Starship setup complete!"
