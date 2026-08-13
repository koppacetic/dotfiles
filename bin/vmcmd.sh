#!/bin/bash

if [[ -z "$1" ]]; then
    echo "USAGE: vmcmd.sh <vmname_pattern> <command> [args]"
    exit 0
fi
VMPATTERN=$1
shift
CMD=$1
shift

abort() {
    echo $1
    exit 1
}

echo "COMMAND: virsh ${CMD} $@"
echo "======== VMs ========"
virsh --readonly list --all | grep $VMPATTERN
echo
echo -n "Run command these VMs? (Type 'yes' to confirm): "
read confirm
if [[ "$confirm" != "yes" ]]; then
    exit 0
fi

for vm in $(virsh --readonly list --all); do
    if [[ $vm =~ $VMPATTERN ]]; then
        echo "======== $vm"
        echo virsh $CMD $@ $vm
        virsh $CMD $@ $vm
    fi
done
