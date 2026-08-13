#!/bin/bash

if [[ -z "$1" ]]; then
    echo "USAGE: vmshow.sh <vmname_pattern>"
    exit 0
fi
VMPATTERN=$1

abort() {
    echo $1
    exit 1
}

for vm in $(virsh --readonly list --all); do
    if [[ $vm =~ $VMPATTERN ]]; then
        echo "======== $vm"
        virsh snapshot-list $vm
    fi
done
