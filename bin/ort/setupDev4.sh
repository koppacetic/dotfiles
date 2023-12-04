#!/bin/bash
USAGE="USAGE: setupDev4.sh"

cd $HOME
if [[ ! -f dev4.lst ]]; then
    echo "ERROR: No dev4.lst file found"
    exit 1
fi

for DEST in $(cat dev4.lst); do
    ssh-copy-id $DEST || exit 1

    case "$DEST" in
    dev4Vault)
        echo 'export VAULT_ADDR="http://127.0.0.1:8200"' > tmp/vault.rc
        echo 'export VAULT_SKIP_VERIFY=true' >> tmp/vault.rc
        echo 'export VAULT_TOKEN=$(cat root_token.txt)' >> tmp/vault.rc
        cat .bashrc.local >> tmp/vault.rc
        scp tmp/vault.rc $DEST:.bashrc.local
        ;;
    dev4Workers)
        scp .bashrc.local $DEST:
        ssh $DEST mkdir bin
        scp bin/ort/enableWorkers.sh $DEST:bin
        scp bin/ort/updateWorkers.sh $DEST:bin
        ;;
    dev4Resources)
        scp .bashrc.local $DEST:
        ssh $DEST mkdir bin
        scp bin/ort/updateResourceMan.sh $DEST:bin
        ;;
    dev4Results)
        scp .bashrc.local $DEST:
        ssh $DEST mkdir bin
        scp bin/ort/updateResultsMan.sh $DEST:bin
        ;;
    *)
        scp .bashrc.local $DEST:
        ;;
    esac

    scp .bashrc-ort $DEST:.bashrc
    scp .gitconfig $DEST:
    scp .gitignore $DEST:
    scp .screenrc $DEST:
    scp .vimrc-lite $DEST:.vimrc
done
