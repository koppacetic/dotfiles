#!/bin/bash
USAGE="startWorkers.sh [--enable]"
WORKERS="10:cleanup_router_worker"
# WORKERS="
# 10:cleanup_router_worker
# 10:git_cleanup_worker
# 10:git_worker
# 10:hal_worker
# 10:provision_begin_worker
# 10:provision_cert_worker
# 10:provision_cleanup_worker
# 10:provision_ip_worker
# 5:provision_kvm_worker
# 10:results_worker
# 10:solve_cleanup_worker
# 5:solve_worker
# 1:start_router_worker
# 10:start_worker
# 5:test_worker
# "

if [[ "$1" == "--help" ]]; then
    echo $USAGE
    exit 0
elif [[ "$1" == "--enable" ]]; then
    doEnable=1
fi

for worker in $WORKERS; do
    num=$(echo $worker | cut -d: -f1)
    name=$(echo $worker | cut -d: -f2)
    echo "==== Starting $num instances of $name"
    systemctl start $name@{1..$num}
    if [[ -n "$doEnable" ]]; then
        systemctl enable $name@{1..$num}
    fi
done
