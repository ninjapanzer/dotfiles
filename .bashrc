HOMEBREW=/usr/local/bin

BREW_SBIN=/usr/local/sbin

RVM="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

SUBL="/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl"
SUBL2="/Applications/Development/Editors/Sublime\\ Text\\ 2.app/Contents/SharedSupport/bin/subl"
LIGHT="/Applications/LightTable/light"
PERSONALBIN=$HOME/bin
COMPOSERBIN=$HOME/.composer/vendor/bin
PHP70=$(brew --prefix php70)/bin

GPG_TTY=$(tty)
export GPG_TTY

export SUBL=$SUBL
export SUBL2=$SUBL2

export ACTIVATOR=$ACTIVATOR

export LIGHT=$LIGHT

export PATH=$PHP70:$PERSONALBIN:$COMPOSERBIN:$HOMEBREW:$BREW_SBIN:$RVM:$PATH

export EDITOR=$SUBL

export NVM_DIR="/Users/paulscoder/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

launchctl setenv PATH $PATH

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

alias pgup='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgdown='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

alias mysqlup='brew unlink mysql56 && brew link mysql && mysql.server start --datadir=/usr/local/var/mysql'
alias mysqldown='mysql.server stop'

alias mysql56up='brew unlink mysql && brew link mysql56 && mysql.server start --datadir=/usr/local/var/mysql56'
alias mysql56down='mysql.server stop'

alias serve='python -m SimpleHTTPServer'
alias phpserve='php -S localhost:8888 -t .'

alias subl=$SUBL
alias subl2=$SUBL2

alias activator=$ACTIVATOR

alias light=$LIGHT

alias gco='git checkout'
alias gb='git branch'

alias ugh='rm -rf node_modules/ bower_components/ && npm cache clean && bower cache clean && npm i && bower i'

