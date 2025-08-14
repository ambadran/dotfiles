
### Homebrew
eval $(/opt/homebrew/bin/brew shellenv)

### Python Stuff
# PyENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

### micropython stuff
export EDITOR=vim  # I LOVE MPREMOTE

### Microchip
export PATH=/Applications/microchip/xc8/v2.32/bin:$PATH
export PATH=/Applications/microchip/xc16/v1.70/bin:$PATH
export PATH=/Applications/microchip/xc32/v4.00/bin:$PATH

### arduino-cli
alias arduino-cli-compile="arduino-cli compile --fqbn $fqbn"
alias arduino-cli-upload="arduino-cli compile --fqbn $fqbn -p $arduino_port"

### Pico SDK
export PICO_SDK_PATH=~/rp2040/pico-sdk

### Miscilaneous
alias esptool='python3 -m esptool'
# Function to automatically push latest changes to my dotfiles to the Mac repo
function update_dotfiles() {
  git -C ~/.dotfiles checkout Mac

  cp ~/.vimrc ~/.dotfiles/
  cp ~/.zshrc ~/.dotfiles/
  cp ~/.zshenv ~/.dotfiles/
  cp ~/.zshprofile ~/.dotfiles/
  cp ~/.tmux.conf ~/.dotfiles/

  git -C ~/.dotfiles add .
  git -C ~/.dotfiles commit -m "Added latest Mac dotfiles"
  git -C ~/.dotfiles push origin Mac
}

### NVM stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completi

# function clear {
#     osascript -e 'tell application "System Events" to keystroke "k" using command down'
# }
alias lsusb="ioreg -p IOUSB -w0 | sed 's/[^o]*o //; s/@.*$//' | grep -v '^Root.*'"

alias pcb_cam="python3 ~/programming_projects/pcb-cam/cli.py"

alias stcproject="python3 ~/.stc/makefile-generator/cli.py"

alias add_git_files="cp ~/.dotfiles/.gitignore ~/.dotfiles/.gitattributes ."

alias picocom="picocom --escape f"
alias picocomb="picocom --escape f -b 115200"
alias picocombu="picocom --escape f -b 115200 /dev/tty.usbserial-0001"

# Created by `pipx` on 2024-09-30 12:33:38
export PATH="$PATH:/Users/ambadran717/.local/bin"

# direnv tool (activates .env environment variables the moment I enter a specific folder ;D )
eval "$(direnv hook zsh)"

# tree without any unwanted files
alias treeclean="tree -I '__pycache__|.git|.venv|*.vim|.pytest_cache|.python-version'"


