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
export HISTFILE="$HOME/.bash_history"

FIGNORE='~:.o'

# OS setup
umask 022
#ulimit -n 10000

# Force hostname on foreign wifi networks
OSNAME=$(uname -s)
if [[ "$OSNAME" = "Darwin" ]]; then
    HNAME=$(scutil --get ComputerName)
else
    HNAME=$(echo $HOSTNAME | cut -d. -f1)
fi
if [[ $UID = 0 ]]; then
    PS1="\A [\u@${HNAME}] \W# "
else
    PS1="\A [\u@${HNAME}] \W> "
fi
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HNAME}\007"'

if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
elif [[ -f /usr/local/etc/bash_completion ]]; then
    . /usr/local/etc/bash_completion
fi

BASEPATH="$HOME/bin"
[[ -d /opt/homebrew/bin ]] && BASEPATH="$BASEPATH:/opt/homebrew/bin"
[[ -d $HOME/.local/bin ]] && BASEPATH="$BASEPATH:$HOME/.local/bin"
BASEPATH="$BASEPATH:/usr/local/bin:/usr/local/sbin"
BASEPATH="$BASEPATH:/bin:/sbin:/usr/bin:/usr/sbin"
[[ -d /usr/local/go/bin ]] && BASEPATH="$BASEPATH:/usr/local/go/bin"
export PATH="$BASEPATH:."

export PAGER="less"
export LESS="-XRem"
export VISUAL="vim"
export MAKEFLAGS="--no-print-directory"
#export RIPGREP_CONFIG_PATH="$HOME/.rgconfig"

# Set CDPATH
BASECD="."
[[ -d $HOME/Projects ]]     && BASECD="$BASECD:$HOME/Projects"
[[ -d $HOME/ort ]]          && BASECD="$BASECD:$HOME/ort"
[[ -d $HOME/dart ]]         && BASECD="$BASECD:$HOME/dart"
[[ -d $HOME/src ]]          && BASECD="$BASECD:$HOME/src"
[[ -d $HOME/osrc ]]         && BASECD="$BASECD:$HOME/osrc"
[[ -d /usr/local/src ]]     && BASECD="$BASECD:/usr/local/src"
BASECD="$BASECD:$HOME"
CDPATH="$BASECD"

# Ruby stuff
eval "$(rbenv init -)"

# Python stuff
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"
export PIPENV_VENV_IN_PROJECT=1
alias psh='pipenv shell'

# Go setup
[[ -d $HOME/go ]] && export GOPATH="$HOME/go"

# Enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias .b="source $HOME/.bashrc"
alias clean='rm -f .*~ .#* *~ *.bak'
alias dif='diff -uwB --color=always'
alias dkps='docker ps'
alias gfb='git flow bugfix'
alias gff='git flow feature'
alias gfh='git flow hotfix'
alias gfr='git flow release'
alias gfs='git flow support'
alias h='history 100'
alias jt='python3 -m json.tool'
alias l='ls -FC --color'
alias ll='ls -la --color'
alias lsd='ls -la --color | grep --color=none ^d'
alias lt='ls -ltr --color'
alias m='less'

# alias dartcli_dev='python3 -m dart_cli.clickcli'
# alias virtcli_dev='python3 -m virt_cli.cli'

s () {
    ssh -t "$1" 'screen -R -D'
}

st () {
    host="$1"
    shift
    if [[ -z "$1" ]]; then
        ssh -t $host "tmux -u2 new-session -As main"
    else
        ssh -t $host "tmux -u2 new-session $@"
    fi
}

hgrep () {
    history | grep --color=always "$@"
}

pid () {
    ps -ef | egrep --color=always "PID|$1" | grep -v grep
}

jtm () {
    python3 -m json.tool "$@" | less
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

# Local config
[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local
