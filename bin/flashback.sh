#!/bin/bash
FLASHDRIVE="/Volumes/FlashBack"
BACKUPDIR="${FLASHDRIVE}/skip/"
DOTFILES=".bash_profile .bashrc* .bash_aliases .gitconfig .gitignore .p10k.zsh .screenrc .tmux.conf .vimrc .zshrc .zshrc.local"
DIRS=".oh-my-sh Documents src osrc Projects TestProjects pcap SRI SnareV1 SnareDemoV1 ort Library/CloudStorage/Dropbox"

cd $HOME
mkdir -p $BACKUPDIR

cp $DOTFILES $BACKUPDIR

for dir in $DIRS; do
    if [[ -d $dir ]]; then
        rsync -Cahrv --exclude=Carthage --exclude=.DS_Store --exclude=.venv --exclude=Documents/Undermine --exclude=Documents/training $1 $dir $BACKUPDIR
    fi
done

#rsync -rpogtkLv --files-from=$HOME/.backupList . $FLASHDRIVE
# [[ -d Documents ]]    && rsync -rpogtkLv Documents $FLASHDRIVE/skip/
# [[ -d src ]]          && rsync -rpogtkLv src $FLASHDRIVE/skip/
# [[ -d SRI ]]          && rsync -rpogtkLv SRI $FLASHDRIVE/skip/
# [[ -d SnareDemoV1 ]]  && rsync -rpogtkLv SnareDemoV1 $FLASHDRIVE/skip/
# [[ -d SnareV1 ]]      && rsync -rpogtkLv SnareV1 $FLASHDRIVE/skip/
# [[ -d Projects ]]     && rsync -rpogtkLv Projects $FLASHDRIVE/skip/
# [[ -d TestProjects ]] && rsync -rpogtkLv TestProjects $FLASHDRIVE/skip/
# [[ -d pcap ]]         && rsync -rpogtkLv pcap $FLASHDRIVE/skip/

#[[ -d Dropbox ]] && rsync -rpogtkLv Dropbox $FLASHDRIVE/skip/
