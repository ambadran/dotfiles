#!/bin/bash

sudo apt update
sudo apt install vim vim-gtk3 tmux xclip xsel wl-clipboard

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cp ~/.dotfiles/.bashprofile ~/
cp ~/.dotfiles/.bashrc ~/
cp ~/.dotfiles/.vimrc ~/
cp ~/.dotfiles/.tmux.conf ~/

tmux source ~/.tmux.conf

# User must now install
# Vim plugins: vim -> :PluginInstall
# Tmux plugins: tmux <key> + I

# Define the target installation directory
PYENV_ROOT="$HOME/.pyenv"

# --- 1. Install pyenv if not present ---
if [ ! -d "$PYENV_ROOT" ]; then
  echo "pyenv not found. Installing..."
  curl -fsSL https://pyenv.run | bash
else
  echo "pyenv is already installed."
fi

# --- 2. Install pyenv-virtualenv plugin if not present ---
PLUGIN_DIR="$PYENV_ROOT/plugins/pyenv-virtualenv"
if [ ! -d "$PLUGIN_DIR" ]; then
  echo "pyenv-virtualenv plugin not found. Installing..."
  # We use PYENV_ROOT directly since the `pyenv` command may not be in the script's PATH
  git clone https://github.com/pyenv/pyenv-virtualenv.git "$PLUGIN_DIR"
else
  echo "pyenv-virtualenv plugin is already installed."
fi

echo "Installation checks complete."
exec "$SHELL"
