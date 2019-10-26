# Bash setup
set -o emacs

shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize

unset HISTFILESIZE
HISTSIZE=100000
HISTCONTROL=ignoreboth
HISTIGNORE='bg:fs:history:gh'
HISTTIMEFORMAT='%F %T '

FIGNORE='~:.o'

# OS setup
umask 022
ulimit -n 10000

# Force hostname on foreign wifi networks
OSNAME=$(uname -s)
if [ "$OSNAME" = "Darwin" ]; then
    HNAME=$(scutil --get ComputerName)
else
    HNAME=$(echo $HOSTNAME | cut -d. -f1)
fi
PS1="\A [\u@${HNAME}] \W> "
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HNAME}\007"'

# Set bash history file based on hostname (sans domain)
if [ "$USER" = "skip" ]; then
    export HISTFILE="$HOME/.history/bash/$HNAME"
else
    export HISTFILE="~skip/.history/bash/${HNAME}-${USER}"
fi

# Set mysql history file based on hostname (sans domain)
export MYSQL_HISTFILE="$HOME/.history/mysql/$HNAME"

if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

# Coreutils stuff
[ -L /usr/local/opt/coreutils ] && MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# Java stuff
#[ -x /usr/libexec/java_home ] && export JAVA_HOME=$(/usr/libexec/java_home)

# Go stuff
export GOPATH="$HOME/go"

BASEPATH="$HOME/bin"
[ -L /usr/local/opt/coreutils ] && BASEPATH="$BASEPATH:/usr/local/opt/coreutils/libexec/gnubin"
#[ -d $HOME/Library/Python/3.7/bin ] && BASEPATH="$BASEPATH:$HOME/Library/Python/3.7/bin"
#[ -L /usr/local/opt/go/libexec/bin ] && BASEPATH="$BASEPATH:/usr/local/opt/go/libexec/bin"
[ -d $GOPATH/bin ] && BASEPATH="$BASEPATH:$GOPATH/bin"
#[ -L /usr/local/opt/ruby ]      && BASEPATH="$BASEPATH:/usr/local/opt/ruby/bin"
#[ -L /usr/local/opt/php54 ]     && BASEPATH="$BASEPATH:/usr/local/opt/php54/bin"
[ -n "$JAVA_HOME" -a -d $JAVA_HOME/bin ] && BASEPATH="$BASEPATH:$JAVA_HOME/bin"
BASEPATH="$BASEPATH:/usr/local/bin:/usr/local/sbin"
BASEPATH="$BASEPATH:/bin:/sbin:/usr/bin:/usr/sbin"
[ -d /usr/local/mysql/bin ]  && BASEPATH="$BASEPATH:/usr/local/mysql/bin"
#[ -d /usr/X11R6/bin ]        && BASEPATH="$BASEPATH:/usr/X11R6/bin"
[ -d "/Applications/Visual Studio Code.app" ] && BASEPATH="$BASEPATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$BASEPATH:."
export PAGER="less"
export LESS="-XRem"
export VISUAL="vim"
export MAKEFLAGS="--no-print-directory"

# Set CDPATH
BASECD="."
[ -d $HOME/SRI ]          && BASECD="$BASECD:$HOME/SRI"
[ -d $HOME/src ]          && BASECD="$BASECD:$HOME/src"
[ -d $HOME/Projects ]     && BASECD="$BASECD:$HOME/Projects"
[ -d $HOME/TestProjects ] && BASECD="$BASECD:$HOME/TestProjects"
[ -d /usr/local/src ]     && BASECD="$BASECD:/usr/local/src"
BASECD="$BASECD:$HOME"
CDPATH="$BASECD"

# Homebrew stuff
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# SRI stuff
# export ENVI="develop"
# alias sbsql='docker exec -it switchboard_postgres_1 psql -U postgres crucible'
# alias dps='docker ps --format "table {{.ID}}  {{.Names}}\t{{.RunningFor}}\t{{.Status}}\t{{.Command}}\t{{.Ports}}"'

# Ruby stuff
[ -x /usr/local/bin/rbenv ] && eval "$(/usr/local/bin/rbenv init -)"

# Python stuff
#export WORKON_HOME="$HOME/Envs"
#mkdir -p $WORKON_HOME
#source /usr/local/bin/virtualenvwrapper.sh
# [ -x /usr/local/bin/pyenv ] && eval "$(/usr/local/bin/pyenv init -)"
# gpip2() {
#    PIP_REQUIRE_VIRTUALENV="" pip2 "$@"
# }
# gpip3() {
#    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
# }

alias .b="source $HOME/.bashrc"
alias clean='rm -f .*~ .#* *~ *.bak'
alias chrome='open -a "Google Chrome"'
alias gff='git flow feature'
alias gfh='git flow hotfix'
alias gfr='git flow release'
alias gfs='git flow support'
alias h='history 100'
alias l='ls -NFC --color=auto'
alias ll='ls -Nla --color=auto'
alias lsd='ls -Nla --color | egrep --color=none "^d|^l"'
alias lt='ls -Nltr --color=auto'
alias m='less'
alias myip="curl icanhazip.com"
alias msn='mysql --auto-rehash --safe-updates --show-warnings -uroot -p'
alias mystart='mysql.server start'
alias mystop='mysqladmin -uroot -p shutdown'
alias prov='openssl smime -inform der -verify -in'
alias srcCopy='rsync -Cavz --exclude-from=$HOME/bin/srcCopy.exclude'
alias xs="startx > $HOME/tmp/x11.log 2>&1 &"

alias t='top -o time -n 30 -s 3'
alias cpu='top -o cpu'
alias mem='top -o rsize' # memory

if [ "$OSNAME" = "Darwin" ]; then
    export DD="$HOME/Library/Developer/Xcode/DerivedData"
    export SDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
    export FW="$SDK/System/Library/Frameworks"

    alias flush="sudo killall -HUP mDNSResponder"
    alias Quotes='/Users/skip/Library/Developer/Xcode/DerivedData/Quotes-dlqxfxvejujgnqffxhvowwvpneii/Build/Products/Debug/Quotes'
    alias lsregister='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'
    alias wifi="networksetup -setairportpower en0"
    alias PlistBuddy="/usr/libexec/PlistBuddy"

    man() {
        if [ $# -eq 1 ]; then
            open x-man-page://$1
        elif [ $# -eq 2 ]; then
            open x-man-page://$1/$2
        fi
    }
fi

s () {
    ssh -t "$1" 'screen -R -D'
}

st () {
    host="$1"
    shift
    ssh -t $host "tmux -u2 $@"
}

sshclean() {
    if [ -z "$1" ]; then
        echo "USAGE: sshclean host"
    else
        ip=$(host $1 | grep -v alias |head -1 | awk '{print $4}')
        echo gsed --in-place -e "/^$1/d" -e "/^${ip}/d" -e "/,${ip} /d" $HOME/.ssh/known_hosts
        gsed --in-place -e "/^$1/d" -e "/^${ip}/d" -e "/,${ip} /d" $HOME/.ssh/known_hosts
    fi
}

gh () {
    history | grep --color "$@"
}

pid () {
    if [ "$OSNAME" = "Darwin" ]; then
        ps aux | egrep --color=always "PID|$1" | grep -v grep
    else
        ps -ef | egrep --color=always "PID|$1" | grep -v grep
    fi
}

pw () {
    gpg -d -o - ~/Dropbox/Home/.private/.passwords.gpg | grep --color -i $1
}

xd () {
    export DISPLAY=${1}:0.0
}

json() {
    curl -s "$@" | sed -e 's/{/{\n/g' -e 's/}/\n}/g' -e 's/,/,\n/g'
}

sdkgrep () {
    ag "$@" /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
}

charlesProxy () {
    export HTTP_PROXY="http://localhost:8888"
    export HTTPS_PROXY="http://localhost:8888"
}

srcZip () {
    if [ -z "$1" ]; then
        echo "USAGE: srcZip dir"
    else
        rm -f $1.zip
        zip -r -o $1.zip $1 -x '*/.git/*' -x '*/Pods/*' -x '*/Carthage/*'
    fi
}
