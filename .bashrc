# ==============================================================================
# 1. Core System & Interactive Checks
# ==============================================================================
# If not running interactively, don't do anything (CRITICAL for scp/rsync)
case $- in
    *i*) ;;
      *) return;;
esac

# ==============================================================================
# 2. History Settings (Developer Optimized)
# ==============================================================================
HISTCONTROL=ignoreboth:erasedups # Ignore spaces and remove duplicates
shopt -s histappend              # Append to history, don't overwrite
HISTSIZE=100000                  # Keep 100,000 lines of history
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T "          # Add timestamps to the 'history' command

# ==============================================================================
# 3. Window & Directory Settings
# ==============================================================================
shopt -s checkwinsize            # Update window size after every command (Crucial for Tmux)
shopt -s autocd                  # Type a directory name to cd into it automatically

# ==============================================================================
# 4. Color Support & Aliases
# ==============================================================================
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Source external aliases file if it exists
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ==============================================================================
# 5. Bash Completion (Tab Autocomplete)
# ==============================================================================
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Enable fzf keybindings for Bash (Ctrl+R history search, etc.)
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash


# ==============================================================================
# 6. Custom Environment & Workflow
# ==============================================================================

# --- Virtual Environments (direnv) ---
# Automatically sources .venv/bin/activate and .env upon entering a directory
eval "$(direnv hook bash)"

# --- Editor (Neovim Override) ---
export EDITOR=nvim
alias vim="nvim"
alias vi="nvim"
alias batcato='batcat --style=numbers --color=always {}'
alias vimfzf='nvim $(fzf --preview=batcato)'

# --- Hardware & Embedded Toolchains ---

# Wine (FlatCAM)
alias run_flatcam='wine start $HOME/.wine/drive_c/Program\ Files/FlatCAM/FlatCAM.exe'

# Microchip (MPLAB X / XC Compilers)
export ipecmd=/opt/microchip/mplabx/v6.10/mplab_platform/mplab_ipe/ipecmd.sh
export PATH="/opt/microchip/xc8/v2.50/bin:$PATH"
export PATH="/opt/microchip/xc16/v2.10/bin:$PATH"
export PATH="/opt/microchip/xc32/v2.45/bin:$PATH"

# STC
alias stcproject="uv run $HOME/.stc/makefile-generator/cli.py"

# STM32
export PATH="/opt/gcc-arm-none-eabi-10.3-2021.10/bin:$PATH"
export STM32CubeMX_PATH=$HOME/STM32CubeMX

# RP2040
export PICO_SDK_PATH=$HOME/.rp/pico-sdk
alias picotool=$HOME/.rp/picotool/build/picotool
alias rpproject="uv run $HOME/.rp/rp-cmake-generator/cli.py"

# Teensy 4.1 (i.MXRT)
export PATH="$HOME/MicroControllers/i.MXRT/teensy_loader_cli:$PATH"

# Arduino CLI 
arduino_compile() {
  arduino-cli compile --fqbn "$fqbn" "$@"
}
arduino_upload() {
  arduino-cli upload -p "$arduino_port" --fqbn "$fqbn" "$@"
}
alias arduino-cli-compile="arduino_compile"
alias arduino-cli-upload="arduino_upload"

# PlatformIO
export PATH="$HOME/.platformio/penv/bin/:$PATH"

# --- Communications & Serial (Picocom) ---
alias picocom="picocom --escape f"
alias picocomb="picocom --escape f -b 115200"
alias picocombu="picocom --escape f -b 115200 /dev/ttyUSB0"
alias picocombc="picocom --escape f -c -b 115200"
alias picocombuc="picocom --escape f -c -b 115200 /dev/ttyUSB0"
picocomu() {
  picocom --escape f -b "$1" /dev/ttyUSB0
}
picocomuc() {
  picocom --escape f -c -b "$1" /dev/ttyUSB0
}

# --- Utilities & Scripts ---

# PCB CAM alias
alias pcb_cam="uv run $HOME/programming_projects/pcb-cam/cli.py"

# Clean Tree view (Ignores build artifacts and virtual envs)
alias treeclean="tree -I '__pycache__|.git|.venv|*.vim|.pytest_cache|.python-version|*.egg-info|.pio|node_modules|build|.gradle|*-backups'"

# Git Setup Shortcut
alias add_git_files="cp $HOME/.dotfiles/.gitignore $HOME/.dotfiles/.gitattributes ."

# Dotfiles Updater
# (Symlinks mean the files are already updated in the repo. Just commit & push!)
function update_dotfiles() {
  git -C $HOME/.dotfiles checkout linux
  git -C $HOME/.dotfiles add .

  # Check if there are changes to commit
  if ! git -C $HOME/.dotfiles diff-index --quiet HEAD --; then
    git -C $HOME/.dotfiles commit -m "Automated update of linux dotfiles"
    git -C $HOME/.dotfiles push origin linux
    echo "Dotfiles successfully pushed to 'linux' branch!"
  else
    echo "No new changes to push."
  fi
}

# Dotfiles Puller
# Symlinks ensure the system immediately uses the pulled files
function pull_dotfiles() {
  git -C $HOME/.dotfiles pull origin linux
  echo "Dotfiles successfully pulled from 'linux' branch!"
}

# --- Node / Android / CUDA ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export CAPACITOR_ANDROID_STUDIO_PATH=$HOME/android-studio/bin/studio.sh
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# # Point Mermaid to the system Chromium
# export PUPPETEER_EXECUTABLE_PATH=$(find $HOME/.cache/puppeteer -type f -name "chrome-headless-shell" | head -n 1)
# # Live terminal image preview with entr and chafa (Linux Alacritty version)
# live_preview() {
#     if [ -z "$1" ]; then
#         echo "Error: No file provided. Usage: preview <filename.png>"
#         return 1
#     fi
#     feh -R 1 -. "$1" &
# }

if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi

# ==============================================================================
# 8. Starship Prompt Initialization
# ==============================================================================
eval "$(starship init bash)"

