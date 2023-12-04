#!/bin/bash

if [[ -z "$1" ]]; then
    echo "USAGE: vmdel.sh <vmname_pattern>"
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

vmDelete() {
    VMNAME=$1

    isRunning=$(virsh list --state-running | grep $VMNAME)
    if [[ -n "$isRunning" ]]; then
        echo "Shutting down $VMNAME..."
        virsh shutdown $VMNAME || abort "Error shutting down $VMNAME"
        waitForShutdown $VMNAME
    fi

    for snap in $(virsh snapshot-list $VMNAME | tail +3 | awk '{print $1}'); do
        echo "Deleting snapshot ${VMNAME}.${snap}..."
        virsh snapshot-delete $VMNAME --snapshotname $snap || abort "Error deleting snapshot ${VMNAME}.${snap}"
    done

    echo "Undefining $VMNAME..."
    virsh undefine $VMNAME --remove-all-storage --delete-storage-volume-snapshots --checkpoints-metadata
}

echo "======== VMs to delete ========"
virsh --readonly list --all | grep $VMPATTERN
echo
echo -n "Delete these VMs? (Type 'yes' to confirm): "
read confirm
if [[ "$confirm" != "yes" ]]; then
    exit 0
fi

for vm in $(virsh list --all); do
    if [[ $vm =~ $VMPATTERN ]]; then
        echo "======== $vm"
        vmDelete $vm
        echo ""
    fi
done

