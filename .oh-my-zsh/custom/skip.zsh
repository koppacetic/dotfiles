#setopt cd_silent

# Customize $PATH
BASEPATH="$HOME/bin"
[[ -L /usr/local/opt/coreutils ]] && BASEPATH="$BASEPATH:/usr/local/opt/coreutils/libexec/gnubin"
[[ -L /usr/local/opt/findutils ]] && BASEPATH="$BASEPATH:/usr/local/opt/findutils/libexec/gnubin"
[[ -L /usr/local/opt/gnu-sed ]] && BASEPATH="$BASEPATH:/usr/local/opt/gnu-sed/libexec/gnubin"
[[ -d $HOME/.gem/ruby/3.0.0/bin ]] && BASEPATH="$BASEPATH:$HOME/.gem/ruby/3.0.0/bin"
#[[ -d $GOPATH/bin ]] && BASEPATH="$BASEPATH:$GOPATH/bin"
#[[ -n "$JAVA_HOME" -a -d $JAVA_HOME/bin ]] && BASEPATH="$BASEPATH:$JAVA_HOME/bin"
[[ -d /usr/local/mysql/bin ]] && BASEPATH="$BASEPATH:/usr/local/mysql/bin"
[[ -d "/Applications/Visual Studio Code.app" ]] && BASEPATH="$BASEPATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
[[ -d /opt/X11/bin ]] && BASEPATH="$BASEPATH:/opt/X11/bin"
BASEPATH="$BASEPATH:/usr/local/bin:/usr/local/sbin"
BASEPATH="$BASEPATH:/bin:/sbin:/usr/bin:/usr/sbin"
export PATH="$BASEPATH:."

# Customize $CDPATH
BASECD="."
[[ -d $HOME/ort ]]          && BASECD="$BASECD:$HOME/ort"
[[ -d $HOME/dart ]]         && BASECD="$BASECD:$HOME/dart"
[[ -d $HOME/src ]]          && BASECD="$BASECD:$HOME/src"
[[ -d $HOME/osrc ]]         && BASECD="$BASECD:$HOME/osrc"
[[ -d $HOME/Projects ]]     && BASECD="$BASECD:$HOME/Projects"
[[ -d $HOME/TestProjects ]] && BASECD="$BASECD:$HOME/TestProjects"
[[ -d /usr/local/src ]]     && BASECD="$BASECD:/usr/local/src"
BASECD="$BASECD:$HOME"
CDPATH="$BASECD"

export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"
export LESS="-XRem"
export MAKEFLAGS="--no-print-directory"
#export RIPGREP_CONFIG_PATH="$HOME/.rgconfig"

OSNAME=$(uname -s)
if [[ "$OSNAME" = "Darwin" ]]; then
    export DD="$HOME/Library/Developer/Xcode/DerivedData"
    export SDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
    export FW="$SDK/System/Library/Frameworks"

    # Homebrew stuff
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    export HOMEBREW_NO_ASK=1
fi

# Python stuff
export PIPENV_VENV_IN_PROJECT=1
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
[[ -x /usr/local/bin/pyenv ]] && eval "$(/usr/local/bin/pyenv init --path)"
alias aenv='deactivate &> /dev/null; source ./.venv/bin/activate'
alias denv='deactivate'
alias psh='pipenv shell'

# Ruby stuff
[[ -x /usr/local/bin/rbenv ]] && eval "$(/usr/local/bin/rbenv init -)"

# Go stuff
#export GOPRIVATE="gitlab.private.sec/trapper"

# Rust stuff
[[ -f ~/.cargo/env ]] && source ~/.cargo/env

unalias ls

alias dkps='docker ps'
alias gfb='git flow bugfix'
alias gff='git flow feature'
alias gfh='git flow hotfix'
alias gfr='git flow release'
alias gfs='git flow support'
alias h='history -100'
alias jt='python -m json.tool'
alias l='ls --color=auto -NFC'
alias ll='ls --color=auto -Nla'
alias lt='ls --color=auto -Nltr'
alias m='less'
alias ssync='rsync -Cahrvz --exclude-from=$HOME/.rsync-filter'

# https://0xffsec.com/handbook/discovery-and-scanning/port-scanning/
alias nmapScan='nmap -v -sV -sC -O -T4 -n -Pn -oA nmap_scan'
alias nmapFullScan='nmap -v -sV -sC -O -T4 -n -Pn -p- -oA nmap_fullscan'

if [[ "$OSNAME" = "Darwin" ]]; then
    alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
    alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
    alias lsregister='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'
    alias PlistBuddy="/usr/libexec/PlistBuddy"
    alias tshark='/Applications/Wireshark.app/Contents/MacOS/tshark'

    xman () {
        open x-man-page://"${@}"
    }
fi

s () {
    ssh -t "$1" 'screen -R -D'
}

st () {
    host="$1"
    shift
    if [[ -z "$1" ]]; then
        ssh -t $host "tmux -u2 new -As main"
    else
        ssh -t $host "tmux -u2 $@"
    fi
}

sshclean() {
    if [[ -z "$1" ]]; then
        echo "USAGE: sshclean host"
    else
        ip=$(host $1 | grep -v alias | head -1 | awk '{print $4}')
        echo gsed --in-place -e "/^$1/d" -e "/^${ip}/d" -e "/,${ip} /d" $HOME/.ssh/known_hosts
        gsed --in-place -e "/^$1/d" -e "/^${ip}/d" -e "/,${ip} /d" $HOME/.ssh/known_hosts
    fi
}

hgrep () {
    history -i | grep --color "$@"
}

pid () {
    if [[ "$OSNAME" = "Darwin" ]]; then
        ps aux | egrep --color=always "PID|$1" | grep -v grep
    else
        ps -ef | egrep --color=always "PID|$1" | grep -v grep
    fi
}

jtm () {
    python -m json.tool "$@" | less
}

dif () {
    diff -uwB --color=always "$@"
}

dkstat() {
    containers=$(docker ps -a -q)
    if [[ -n "$containers" ]]; then
        echo "---- CONTAINERS ----"
        docker ps -a
    fi
    images=$(docker images -q)
    if [[ -n "$images" ]]; then
        echo "---- IMAGES ----"
        docker images
    fi
    volumes=$(docker volume ls -q)
    if [[ -n "$volumes" ]]; then
        echo "---- VOLUMES ----"
        docker volume ls
    fi
}

dkclean() {
#    setopt xtrace verbose
    containers=$(docker ps -a -q)
    if [[ -n "$containers" ]]; then
        echo "---- CONTAINERS ----"
        docker stop $(docker ps -a -q)
        docker rm $(docker ps -a -q)
    fi
    images=$(docker images -q)
    if [[ -n "$images" ]]; then
        echo "---- IMAGES ----"
        docker rmi $(docker images -q)
    fi
    volumes=$(docker volume ls -q)
    if [[ -n "$volumes" ]]; then
        echo "---- VOLUMES ----"
        docker volume rm $(docker volume ls -q)
    fi
}

