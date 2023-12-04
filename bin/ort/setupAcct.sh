#!/bin/bash
USAGE="USAGE: setupAcct.sh <host>"

if [[ -z "$1" ]]; then
    echo $USAGE
    exit 1
fi
DEST=$1

cd $HOME
ssh-copy-id $DEST || exit 1

scp .bashrc $DEST:
scp .bashrc.local $DEST:
scp .gitconfig $DEST:
scp .gitignore $DEST:
scp .screenrc $DEST:
scp .tmux.conf $DEST:
#scp .vimrc-lite $DEST:.vimrc

scp dev4.lst $DEST:
#scp .ssh/config.dev $DEST:.ssh/config

ssh $DEST mkdir -p bin ort tmp
scp bin/bcopy $DEST:bin
scp bin/bexec $DEST:bin
