#!/bin/bash

if [[ -z "$1" ]]; then
    echo "USAGE: vmstop.sh <vmname_pattern>"
    exit 0
fi
VMPATTERN=$1

abort() {
    echo $1
    exit 1
}

waitForShutdown() {
    while true; do
        found=$(virsh list --state-shutoff | grep $1)
        [[ -n "$found" ]] && break
        echo -n "."
        sleep 2
    done
    echo ""
}

vmStop() {
    VMNAME=$1

    isRunning=$(virsh list --state-running | grep $VMNAME)
    if [[ -n "$isRunning" ]]; then
        echo "Shutting down $VMNAME..."
        virsh shutdown $VMNAME || abort "Error shutting down $VMNAME"
        waitForShutdown $VMNAME
    fi
}

echo "======== VMs to stop ========"
virsh --readonly list --all | grep $VMPATTERN
echo
echo -n "Stop these VMs? (Type 'yes' to confirm): "
read confirm
if [[ "$confirm" != "yes" ]]; then
    exit 0
fi

for vm in $(virsh list --all); do
    if [[ $vm =~ $VMPATTERN ]]; then
        echo "======== $vm"
        vmStop $vm
        echo ""
    fi
done
