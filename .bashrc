HOMEBREW=/usr/local/bin

BREW_SBIN=/usr/local/sbin

RVM="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

SUBL="/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl"
SUBL2="/Applications/Development/Editors/Sublime\\ Text\\ 2.app/Contents/SharedSupport/bin/subl"

export SUBL=$SUBL
export SUBL2=$SUBL2

export PATH=$HOMEBREW:$BREW_SBIN:$RVM:$PATH

export EDITOR=$SUBL

export NVM_DIR="/Users/samuraipanzer/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

launchctl setenv PATH $PATH

alias pgup='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgdown='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

alias serve='python -m SimpleHTTPServer'

alias subl=$SUBL
alias subl2=$SUBL2

alias ugh='rm -rf node_modules/ bower_components/ && npm cache clean && bower cache clean && npm i && bower i'

