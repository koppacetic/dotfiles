#!/bin/bash
PARENT_DIR="$HOME/ort"
REPOHOSTS="results-manager:dev4Results resource-manager:dev4Resources panda-express:dev4Workers"

abort() {
    echo $1
    exit 1
}

for repohost in $REPOHOSTS; do
    repo=$(echo ${repohost} | cut -d: -f1)
    host=$(echo ${repohost} | cut -d: -f2)

    echo "================ ${repo} ================"
    cd ${PARENT_DIR}/${repo}
    git co develop || abort "Git checkout failed"
    git up || abort "Git update failed"
    python3 ./build_utils.py build || abort "Build failed"
    scp build_output/*.tar.gz ${host}:
    echo ""
done
exit 0
