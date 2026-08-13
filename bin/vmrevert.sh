#!/bin/bash

if [[ -z "$1" || -z "$2" ]]; then
    echo "USAGE: vmrevert.sh <vmname_pattern> <snapshot>"
    exit 0
fi
VMPATTERN=$1
SNAPSHOT=$2


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

vmRevert() {
    VMNAME=$1
    SNAP=$2

    isRunning=$(virsh list --state-running | grep $VMNAME)
    if [[ -n "$isRunning" ]]; then
        echo "Shutting down $VMNAME..."
        virsh shutdown $VMNAME || abort "Error shutting down $VMNAME"
        waitForShutdown $VMNAME
    fi

    echo "Reverting $VMNAME to $SNAP..."
    virsh snapshot-revert $VMNAME --snapshotname $SNAP || abort "Error reverting to ${VMNAME}.${SNAP}"

    echo "Rebooting $VMNAME..."
    virsh reboot $VMNAME || abort "Error starting $VMNAME"
}

echo "SNAPSHOT: ${SNAPSHOT}"
echo "======== VMs to revert ========"
virsh --readonly list --all | grep $VMPATTERN
echo
echo -n "Revert these VMs to '${SNAPSHOT}'? (Type 'yes' to confirm): "
read confirm
if [[ "$confirm" != "yes" ]]; then
    exit 0
fi

for vm in $(virsh list --all); do
    if [[ $vm =~ $VMPATTERN ]]; then
        echo "======== $vm"
        vmRevert $vm $SNAPSHOT
    fi
done

