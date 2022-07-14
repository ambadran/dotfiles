export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PATH=/Applications/microchip/xc8/v2.32/bin:$PATH

export PATH=/Applications/microchip/xc16/v1.70/bin:$PATH

export PATH=/Users/ambadran717/libraries/qt5:$PATH

export PATH=/Applications/microchip/xc32/v4.00/bin:$PATH

alias ampyrun='ampy -p /dev/tty.usbmodem11401 run'
alias ampyput='ampy -p /dev/tty.usbmodem11401 put'
alias ampyls='ampy -p /dev/tty.usbmodem11401 ls'
alias ampyrm='ampy -p /dev/tty.usbmodem11401 rm'

alias rshellrepl='rshell -p /dev/tty.usbmodem11401 --buffer-size 512 repl'
alias rshellmain='rshell -p /dev/tty.usbmodem11401 --buffer-size 512'

