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

# wine shortcuts
alias run_flatcam='wine start /home/mr-atom/.wine/drive_c/Program Files/FlatCAM/FlatCAM.exe'


# micropython stuff
export upy_device=/dev/ttyACM0
export upy_device2=/dev/ttyACM1

alias rshell1='rshell -p $upy_device'
alias ampyrun='ampy -p $upy_device run'
alias ampyput='ampy -p $upy_device put'
alias ampyls='ampy -p $upy_device ls'
alias ampyrm='ampy -p $upy_device rm'
alias ampyrmdir='ampy -p $upy_device rmdir'
alias ampyget='ampy -p $upy_device get'
alias ampyrestart='ampy -p $upy_device run ~/micropython/raspberry_pi_pico/imp_files/soft_reboot.py'
function ampyl() {
  ampy -p $upy_device run "$1" | tee log.txt
}

alias rshell2='rshell -p $upy_device2'
alias ampyrun2='ampy -p $upy_device2 run'
alias ampyput2='ampy -p $upy_device2 put'
alias ampyls2='ampy -p $upy_device2 ls'
alias ampyrm2='ampy -p $upy_device2 rm'
alias ampyrmdir2='ampy -p $upy_device2 rmdir'
alias ampyget2='ampy -p $upy_device2 get'
alias ampyrestart2='ampy -p $upy_device2 run ~/micropython/raspberry_pi_pico/imp_files/soft_reboot.py'
function ampyl2() {
  ampy -p $upy_device2 run "$1" | tee log.txt
}

### microchip stuff
export ipecmd=/opt/microchip/mplabx/v6.10/mplab_platform/mplab_ipe/ipecmd.sh
export PATH="/opt/microchip/xc8/v2.50/bin:$PATH"
export PATH="/opt/microchip/xc16/v2.10/bin:$PATH"
export PATH="/opt/microchip/xc32/v2.45/bin:$PATH"

### STM32 stuff
export PATH="/opt/gcc-arm-none-eabi-10.3-2021.10/bin:$PATH"

### RP2040 stuff
export PICO_SDK_PATH=~/MicroControllers/RP2040/pico/pico-sdk


### Misclaneous
function update_dotfiles() {
  git -C ~/.dotfiles checkout linux

  cp ~/.bashrc ~/.dotfiles/
  cp ~/.bashprofile ~/.dotfiles/
  cp ~/.vimrc ~/.dotfiles/
  cp ~/.tmux.conf ~/.dotfiles/

  git -C ~/.dotfiles add .
  git -C ~/.dotfiles commit -m "Added latest linux dotfiles"
  git -C ~/.dotfiles push origin linux

}

alias create_gcode="python3 -W ignore ~/programming_projects/pcb-cam/cli.py"

alias stcproject="python3 ~/.stc/makefile-generator/cli.py"

alias add_git_files="cp ~/.dotfiles/.gitignore ~/.dotfiles/.gitattributes ."

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
