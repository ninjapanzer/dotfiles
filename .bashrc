
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

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

alias test_servers='rake db:test:prepare && RAILS_ENV=test rake servers:start'
alias test_servers_stop='RAILS_EVN=test rake servers:stop'
