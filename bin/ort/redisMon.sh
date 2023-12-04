#!/bin/bash
REDIS_HOST="dev4Redis"
QUEUES="base_git_in_progress combo_solve_in_progress provision_kvm_in_progress provision_get_ip_in_progress"
QUEUES="$QUEUES provision_add_cert_in_progress combo_test_in_progress"

QUEUES="$QUEUES start_router combo_solve base_git provision_kvm "
QUEUES="$QUEUES provision_get_ip provision_add_cert"
QUEUES="$QUEUES combo_test combo_provision_cleanup base_cleanup combo_store_result"

if [[ -n "$1" ]]; then
    REDIS_HOST=$1
fi

echo "REDIS_HOST: $REDIS_HOST"
echo "=-=-=-=-=-=-=-=Provisioning Keys-=-=-=-=-=-=-=-=-="
for key in $QUEUES; do
	echo -n "$key: "
    redis-cli -h $REDIS_HOST --raw llen $key
done

echo ""
echo "=-=-=-=-=-=-=-=-=-All Keys=-=-=-=-=-=-=-="
redis-cli -h $REDIS_HOST keys \*

