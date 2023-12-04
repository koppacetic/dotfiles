#!/bin/bash

if [[ -z "$1" ]]; then
    echo "USAGE: setupvm.sh <host>"
    exit 1
fi

cd $HOME
scp Dropbox/Home/.bashrc-lite $1:.bashrc
scp Dropbox/Home/.vimrc-lite $1:.vimrc

scp .gitconfig .gitignore $1:
scp .screenrc .tmux.conf $1:

exit 0
