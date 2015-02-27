source $HOME/.bashrc
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}
