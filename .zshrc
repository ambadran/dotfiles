
### micropython stuff
export EDITOR=vim  # I LOVE MPREMOTE

### Microchip
export PATH="/Applications/microchip/xc8/v2.32/bin:$PATH"

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
# function clear {
#     osascript -e 'tell application "System Events" to keystroke "k" using command down'
# }
alias list_usb="ioreg -p IOUSB -w0 | sed 's/[^o]*o //; s/@.*$//' | grep -v '^Root.*'"

alias create_gcode="python3 -W ignore ~/programming_projects/pcb-cam/cli.py"

alias stcproject="python3 ~/.stc/makefile-generator/cli.py"

alias add_git_files="cp ~/.dotfiles/.gitignore ~/.dotfiles/.gitattributes ."

alias picocomf="picocom --escape f"
alias picocomfb="picocom --escape f -b 115200"
alias picocomfbu="picocom --escape f -b 115200 /dev/tty.usbserial-0001"



# Created by `pipx` on 2024-09-30 12:33:38
export PATH="$PATH:/Users/ambadran717/.local/bin"
