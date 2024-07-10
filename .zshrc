
### micropython stuff
export upy_device=usbmodem101
export upy_device2=usbmodem1101

alias rshell1='rshell -p /dev/tty.$upy_device'
alias ampyrun='ampy -p /dev/tty.$upy_device run'
alias ampyput='ampy -p /dev/tty.$upy_device put'
alias ampyls='ampy -p /dev/tty.$upy_device ls'
alias ampyrm='ampy -p /dev/tty.$upy_device rm'
alias ampyget='ampy -p /dev/tty.$upy_device get'
alias ampyblinkled='ampy -p /dev/tty.$upy_device run /Users/ambadran717/micropython/raspberry_pi_pico/imp_files/led_blink.py'
alias ampysoftreboot='ampy -p /dev/tty.$upy_device run /Users/ambadran717/micropython/raspberry_pi_pico/imp_files/soft_reboot.py'
# runs a py file and puts output in log.txt
function ampyl() {
    ampy -p /dev/tty.usbmodem$upy_device run "$1" | tee log.txt
}

alias rshell2='rshell -p /dev/tty.$upy_device2'
alias ampyrun2='ampy -p /dev/tty.$upy_device2 run'
alias ampyput2='ampy -p /dev/tty.$upy_device2 put'
alias ampyls2='ampy -p /dev/tty.$upy_device2 ls'
alias ampyrm2='ampy -p /dev/tty.$upy_device2 rm'
alias ampyget2='ampy -p /dev/tty.$upy_device2 get'
alias ampyblinkled2='ampy -p /dev/tty.$upy_device2 run /Users/ambadran717/micropython/raspberry_pi_pico/imp_files/led_blink.py'
alias ampysoftreboot2='ampy -p /dev/tty.$upy_device2 run /Users/ambadran717/micropython/raspberry_pi_pico/imp_files/soft_reboot.py'
# runs a py file and puts output in log.txt
function ampyl2() {
    ampy -p /dev/tty.usbmodem$upy_device2 run "$1" | tee log.txt
}

### Microchip
export PATH="/Applications/microchip/xc8/v2.32/bin:$PATH"

### Pico SDK
export PICO_SDK_PATH='~/rp2040/pico-sdk'

### Miscilaneous
# Function to automatically push latest changes to my dotfiles to the Mac repo
function upload_dotfiles() {
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

alias stcproject="python3 ~/.stc/makefile-generator/cli.py"

alias add_git_files="cp ~/.dotfiles/.gitignore ~/.dotfiles/.gitattributes ."

