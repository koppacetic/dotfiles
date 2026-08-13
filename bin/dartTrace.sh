#!/bin/bash
USAGE="dartTrace.sh <id>\n    <id> can be a plan_id or a combo_id"
WORKERS="start git solve provision_kvm provision_ip provision_cert test results solve_cleanup provision_cleanup"

if [[ -z "$1" ]]; then
    echo -e $USAGE
    exit 1
fi
ID=$1

for worker in $WORKERS; do
    echo "-------- $worker"
    grep $ID /var/log/${worker}_worker.log | sed -e 's/^[^{]*{//'
done

exit 0
