ulimit -n 1024
ulimit -u 1024

source $HOME/.bashrc
source $HOME/.profile

[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/samuraipanzer/.sdkman"
[[ -s "/Users/samuraipanzer/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/samuraipanzer/.sdkman/bin/sdkman-init.sh"
