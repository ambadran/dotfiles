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

# On macOS and Linux.
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Installation checks complete."
exec "$SHELL"
