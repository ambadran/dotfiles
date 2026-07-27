# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\] \$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h \W \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \W\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

##############################################################################################
### my stuff

# direnv stuff, automate source .venv/bin/activate and .env in the project folders (and subfolders) once i just cd into them
eval "$(direnv hook bash)"
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV))"
  fi
}
export -f show_virtual_env
PS1='$(show_virtual_env)'$PS1

# editor stuff
alias vim="vim -X"
alias batcato='batcat --style=numbers --color=always {}'
alias vimfzf='vim $(fzf --preview=batcato)'

# wine shortcuts
alias run_flatcam='wine start /home/mr-atom/.wine/drive_c/Program\ Files/FlatCAM/FlatCAM.exe'

# micropython stuff
# migrating to mpremote :D
export EDITOR=vim

### microchip stuff
export ipecmd=/opt/microchip/mplabx/v6.10/mplab_platform/mplab_ipe/ipecmd.sh
export PATH="/opt/microchip/xc8/v2.50/bin:$PATH"
export PATH="/opt/microchip/xc16/v2.10/bin:$PATH"
export PATH="/opt/microchip/xc32/v2.45/bin:$PATH"

### STC stuff
alias stcproject="python3 ~/.stc/makefile-generator/cli.py"

### STM32 stuff
export PATH="/opt/gcc-arm-none-eabi-10.3-2021.10/bin:$PATH"
export STM32CubeMX_PATH=/home/mr-a-717/STM32CubeMX

### RP2040 stuff
export PICO_SDK_PATH=~/.rp/pico-sdk
alias picotool=~/.rp/picotool/build/picotool
alias rpproject="python3 ~/.rp/rp-cmake-generator/cli.py"

### teensy 4.1 (i.MXRT) stuff
export PATH="/home/mr-a-717/MicroControllers/i.MXRT/teensy_loader_cli:$PATH"

### arduino-cli
alias arduino-cli-compile="arduino-cli compile --fqbn $fqbn"
alias arduino-cli-upload="arduino-cli upload -p $arduino_port --fqbn $fqbn"

### PlatformIO stuff
export PATH="/home/mr-a-717/.platformio/penv/bin/:$PATH"

### Misclaneous
function update_dotfiles() {
  git -C ~/.dotfiles checkout linux

  cp ~/.bashrc ~/.dotfiles/
  cp ~/.profile ~/.dotfiles/
  cp ~/.bashprofile ~/.dotfiles/
  cp ~/.vimrc ~/.dotfiles/
  cp ~/.tmux.conf ~/.dotfiles/

  git -C ~/.dotfiles add .
  git -C ~/.dotfiles commit -m "Added latest linux dotfiles"
  git -C ~/.dotfiles push origin linux

}

### Github
alias add_git_files="cp ~/.dotfiles/.gitignore ~/.dotfiles/.gitattributes ."

### Picocom
alias picocom="picocom --escape f"
alias picocomb="picocom --escape f -b 115200"
alias picocombu="picocom --escape f -b 115200 /dev/ttyUSB0"
alias picocombc="picocom --escape f -c -b 115200"
alias picocombuc="picocom --escape f -c -b 115200 /dev/ttyUSB0"
function picocomu() {
  picocom --escape f -b "$1" /dev/ttyUSB0
}
function picocomuc() {
  picocom --escape f -c -b "$1" /dev/ttyUSB0
}

# PCB CAM alias
alias pcb_cam="python3 ~/programming_projects/pcb-cam/cli.py"

# tree without any unwanted files
alias treeclean="tree -I '__pycache__|.git|.venv|*.vim|.pytest_cache|.python-version|*.egg-info|.pio|node_modules|build|.gradle'"



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export CAPACITOR_ANDROID_STUDIO_PATH=~/android-studio/bin/studio.sh

# Point Mermaid to the system Chromium
export PUPPETEER_EXECUTABLE_PATH=$(find ~/.cache/puppeteer -type f -name "chrome-headless-shell" | head -n 1)
# Live terminal image preview with entr and chafa (Linux Alacritty version)
live_preview() {
    if [ -z "$1" ]; then
        echo "Error: No file provided. Usage: preview <filename.png>"
        return 1
    fi
    feh -R 1 -. "$1" &
}


export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
