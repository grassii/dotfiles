export PS1="\[\033[0;34m\]\w\[\033[0;30m\] "

alias fetch="clear; osascript fetch.scpt;rurifetch"
alias rurifetch="neofetch | tr -d : | tr '[:upper:]' '[:lower:]'"

alias aho="ahoviewer"

alias show="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"

alias m="mpd;mpc play;ncmpcpp;mpd --kill;clear"

alias ruri="bash ruri.sh"
alias up="bash ruri-up.sh"
alias scrot="bash ruri-ss.sh"

alias vim="nvim"
alias vi="nvim"
alias vid="nvim -d"

function macfeh() {
    open -b "drabweb.macfeh" "$@"
}

alias firefox="open -a Firefox;clear; echo Starting Firefox; sleep 0.5s; clear; sleep 0.5s; echo Started Firefox; sleep 1.5s; clear"

alias music="osascript tiling.scpt;clear "

alias files="osascript tiling2.scpt;clear;ranger"

alias restart=". ~/.bash_profile;clear"

