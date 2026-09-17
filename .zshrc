# Zsh setup
bindkey -e
unsetopt NOMATCH

#shopt -s histappend
#shopt -s cmdhist
#shopt -s checkwinsize

# -------- History --------
#HISTFILE="$HOME/.zhistory"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

HISTCONTROL=ignoreboth
HISTIGNORE='bg:fs:history:gh'
HISTTIMEFORMAT='%F %T '

# -------- Editor --------
export EDITOR="vim"
export VISUAL="vim"


FIGNORE='~:.o'

# OS setup
umask 022
#ulimit -n 10000

# -------- Prompt--------
# Force hostname on foreign wifi networks
#OSNAME=$(uname -s)
#if [[ "$OSNAME" = "Darwin" ]]; then
#    HNAME=$(scutil --get ComputerName)
#else
#    HNAME=$(echo $HOSTNAME | cut -d. -f1)
#fi
#PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HNAME}\007"'

autoload -U colors && colors

function separator() {
  # tput setaf to set to terminal color 0
  # printf command is used to format and print text to the terminal
  # The %*s format specifier is used to print a string, where the * indicates that the width
  #   of the string should be specified as an argument
  # The ${COLUMNS:-$(tput cols)} expression is used to determine the width of the terminal window.
  # The COLUMNS variable is set by the shell to the number of columns in the terminal window,
  #   and the tput cols command retrieves the number of columns in the terminal window.
  #   The :- operator is used to set a default value for the COLUMNS variable if it is not set.
  #   In this case, the default value is the output of the tput cols command, which retrieves the
  #   number of columns in the terminal window.
  # The tr command is used to replace all spaces in the input string with _
  separation_line=$(tput setaf 0; printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _)
  echo "${separation_line}"
}

function precmd() {
  separator
}

ZLE_RPROMPT_INDENT=0
if [[ $UID = 0 ]]; then
    PROMPT="%{${fg[yellow]}%}%n@%m%{${fg[default]}%}# "
    RPROMPT="%{${fg[cyan]}%}%~ %{${fg[magenta]}%}%T"
else
    PROMPT="%{${fg[yellow]}%}%n@%m%{${fg[default]}%}> "
    RPROMPT="%{${fg[cyan]}%}%~ %{${fg[magenta]}%}%T"
fi

# Homebrew config
export HOMEBREW_NO_ASK=1
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

BASEPATH="$HOME/bin"
[[ -d $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin ]] && BASEPATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$BASEPATH"
[[ -d $HOMEBREW_PREFIX/opt/grep/libexec/gnubin ]] && BASEPATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$BASEPATH"
[[ -d $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin ]] && BASEPATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$BASEPATH"
[[ -d $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin ]] && BASEPATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$BASEPATH"
[[ -d $HOMEBREW_PREFIX/bin ]] && BASEPATH="$BASEPATH:$HOMEBREW_PREFIX/bin"
[[ -d $HOMEBREW_PREFIX/sbin ]] && BASEPATH="$BASEPATH:$HOMEBREW_PREFIX/sbin"
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
[[ -d $HOME/ort ]]        && BASECD="$BASECD:$HOME/ort"
[[ -d $HOME/dart ]]       && BASECD="$BASECD:$HOME/dart"
[[ -d $HOME/Projects ]]   && BASECD="$BASECD:$HOME/Projects"
[[ -d $HOME/src ]]        && BASECD="$BASECD:$HOME/src"
[[ -d $HOME/osrc ]]       && BASECD="$BASECD:$HOME/osrc"
#[[ -d /usr/local/src ]]   && BASECD="$BASECD:/usr/local/src"
BASECD="$BASECD:$HOME"
CDPATH="$BASECD"

# Ruby stuff
[[ -x $HOMEBREW_PREFIX/bin/rbenv ]] && eval "$($HOMEBREW_PREFIX/bin/rbenv init -)"

# Python stuff
#export PYENV_ROOT="$HOME/.pyenv"
#eval "$(pyenv init -)"
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
    TERM=xterm-256color ssh -t "$1" "screen -R -D"
}

st () {
    host="$1"
    shift
    if [[ -n "$1" ]]; then
        TERM=xterm-256color ssh -t $host "tmux -u2 $@"
    else
        TERM=xterm-256color ssh -t $host "tmux -u2 new -As main"
    fi
}

hgrep () {
    history 1 | grep --color=always "$@"
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

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters"
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.secrets ]] && source ~/.secrets

# oMLX: CLI shim path begin
case ":$PATH:" in
  *":$HOME/.omlx/bin:"*) ;;
  *) export PATH="$HOME/.omlx/bin:$PATH" ;;
esac
# oMLX: CLI shim path end

export PATH="/Users/skip/.pixi/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/skip/.lmstudio/bin"
# End of LM Studio CLI section


# Added by MTPLX.app — terminal command
export PATH="$HOME/.mtplx/bin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/skip/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions
