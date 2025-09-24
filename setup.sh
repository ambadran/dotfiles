
sudo apt update
sudo apt install vim vim-gtk3 tmux xclip xsel wl-clipboard

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cp .bashprofile ~/
cp .bashrc ~/
cp .vimrc ~/
cp .tmux.conf ~/

tmux source ~/.tmux.conf

# User must now install
# Vim plugins: vim -> :PluginInstall
# Tmux plugins: tmux <key> + I


# Installing Pyenv
curl -fsSL https://pyenv.run | bash
# Need to refresh to apply pyenv
exec "$SHELL"

# Installing Pyenv virtualenv plugin
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
# Need to refresh to apply pyenv
exec "$SHELL"
