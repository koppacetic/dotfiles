#!/bin/bash
TOP_DIR="$HOME/ort"
USAGE="ghApprove.sh <branch>"

if [[ -z "$1" ]]; then
    echo $USAGE
    exit 1
fi

cd $TOP_DIR
for d in */; do
    echo ======== $d
    cd $d
    gh pr review -a $1
    cd ..
done
