#!/bin/bash
VMHOSTS="kvm-r2-u30.int.qqcyber.net"
VMHOSTS="$VMHOSTS kvm-r2-u34.int.qqcyber.net"
#VMHOSTS="$VMHOSTS kvm-r2-u36.int.qqcyber.net" # Infrostructure
VMHOSTS="$VMHOSTS kvm-r2-u37.int.qqcyber.net"
VMHOSTS="$VMHOSTS kvm-r2-u38.int.qqcyber.net"
CLONE_DIRS="/mnt/clones /mnt/clones2"

# Build list of known VMs
cat /dev/null > /tmp/VMs-tmp.lst
for vmhost in $VMHOSTS; do
    virsh -c "qemu+ssh://$vmhost/system" list --all | tail --lines=+3 | awk '{print $2}' >> /tmp/VMs-tmp.lst
done
sort /tmp/VMs-tmp.lst > /tmp/VMs.lst

# Build list of clones
cat /dev/null > /tmp/Clones-tmp.lst
for cdir in $CLONE_DIRS; do
    cd $cdir
    ls *.qcow2 | sed -e 's/.qcow2//' >> /tmp/Clones-tmp.lst
done
sort /tmp/Clones-tmp.lst > /tmp/Clones.lst

diff -uwB --color=always /tmp/VMs.lst /tmp/Clones.lst
