
### micropython stuff
export upy_device=tty.usbmodem101

alias ampyrun='ampy -p /dev/$upy_device run'
alias ampyput='ampy -p /dev/$upy_device put'
alias ampyls='ampy -p /dev/$upy_device ls'
alias ampyrm='ampy -p /dev/$upy_device rm'
alias ampyget='ampy -p /dev/$upy_device get'
alias ampyblinkled='ampy -p /dev/$upy_device run /Users/ambadran717/micropython/raspberry_pi_pico/imp_files/led_blink.py'
alias ampysoftreboot='ampy -p /dev/$upy_device run /Users/ambadran717/micropython/raspberry_pi_pico/imp_files/soft_reboot.py'
# runs a py file and puts output in log.txt
function ampyl() {
    ampy -p /dev/$upy_device run "$1" | tee log.txt
}


### Microchip
export PATH="/Applications/microchip/xc8/v2.32/bin:$PATH"


### Miscilaneous
# Function to automatically push latest changes to my dotfiles to the Mac repo
function upload_dotfiles() {
  git -C ~/.dotfiles checkout Mac

  cp ~/.vimrc ~/.dotfiles/
  cp ~/.zshrc ~/.dotfiles/
  cp ~/.zshenv ~/.dotfiles/
  cp ~/.zshprofile ~/.dotfiles/

  git -C ~/.dotfiles add .
  git -C ~/.dotfiles commit -m "Added latest Mac dotfiles"
  git -C ~/.dotfiles push origin Mac
}
function clear {
    osascript -e 'tell application "System Events" to keystroke "k" using command down'
}
alias list_usb="ioreg -p IOUSB -w0 | sed 's/[^o]*o //; s/@.*$//' | grep -v '^Root.*'"

function test {
  echo test
}
