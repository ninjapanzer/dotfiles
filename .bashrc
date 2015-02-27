
HOMEBREW=/usr/local/bin

export PYTHONPATH=/usr/local/lib/python2.7/site-packages

BREW_SBIN=/usr/local/sbin

PATH=$BREW_SBIN:$HOMEBREW:$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export EDITOR=vim

launchctl setenv PATH $PATH

alias pgup='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgdown='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
