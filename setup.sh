#!/bin/bash
set -e

echo "Updating APT packages..."
sudo apt update

# Install core packages needed everywhere
sudo apt install -y tmux fzf bat tree direnv picocom git curl btop nvtop duf gdu

echo "Installing Neovim..."

# 1. OS-Aware Installation
if [ "$(uname -m)" == "x86_64" ]; then
    # For Pop!_OS, Ubuntu Server, and Hetzner VPS (Linux x86_64)
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux-x86_64.tar.gz
elif [ "$(uname -m)" == "aarch64" ]; then # NOT TESTED
    # For your Raspberry Pi OS
    # Grabs the pre-compiled ARM binary from Neovim's releases
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
    sudo rm -rf /opt/nvim-linux-arm64
    sudo tar -C /opt -xzf nvim-linux-arm64.tar.gz
    sudo ln -sf /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux-arm64.tar.gz
elif [ "$(uname -m)" == "armv7l" ]; then # NOT TESTED
    # For 32-bit Raspberry Pi OS
    # Neovim does not distribute 32-bit pre-compiled binaries, so we fall back to apt
    sudo apt-get install -y neovim
fi

echo "Setting up Neovim configuration..."

# 2. Create the required Neovim directory
mkdir -p ~/.config/nvim

# 3. Symlink your new init.lua from your dotfiles repository
# (Assuming you save the file we just created as init.lua inside your ~/.dotfiles folder)
ln -sf ~/.dotfiles/init.lua ~/.config/nvim/init.lua

echo "Neovim setup complete."

# ---------------------------------------------------------
# Dynamic Environment Detection
# ---------------------------------------------------------
if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    echo "Desktop environment detected. Installing GUI and clipboard tools..."
    sudo apt install -y  xclip xsel wl-clipboard vim
    # Symlink Alacritty config ONLY on GUI systems
    # (Adjust the path to match where your alacritty config actually lives in your repo)
    echo "Symlinking Alacritty config..."
    mkdir -p ~/.config/alacritty
    ln -sf ~/.dotfiles/alacritty.toml ~/.config/alacritty/alacritty.toml
else
    echo "Headless server detected. Installing minimal CLI tools..."
    # Install standard vim to avoid downloading massive X11/GTK dependencies
    sudo apt install -y vim
fi
# ---------------------------------------------------------

echo "Setting up Plugin Managers..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "Symlinking core dotfiles..."
ln -sf ~/.dotfiles/.bash_profile ~/
ln -sf ~/.dotfiles/.profile ~/.profile
ln -sf ~/.dotfiles/.bashrc ~/
ln -sf ~/.dotfiles/.tmux.conf ~/
# Ensure the target directory exists on the machine
mkdir -p ~/.pi/agent
# Create the symlinks (-s creates the symlink, -f forces overwrite if a file already exists)
ln -sf ~/.dotfiles/pi-agent/settings.json ~/.pi/agent/settings.json
ln -sf ~/.dotfiles/pi-agent/models.json ~/.pi/agent/models.json
ln -sf ~/.dotfiles/pi-agent/pi-permissions.jsonc ~/.pi/agent/pi-permissions.jsonc

echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Installing Starship Prompt..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

echo "======================================================="
echo "Installation checks complete!"
echo " "
echo "Next Steps:"
echo "1. Open tmux and press [Prefix] + Shift-I to install tmux plugins."
echo "2. Type 'nvim' to automatically install lazy.nvim and all your new plugins."
echo "======================================================="

exec "$SHELL"
