#!/bin/bash
USAGE="USAGE: [--flush] updateWorkers.sh <tarfile>"
DO_FLUSH=

source /opt/workers/env.d/common.env

abort () {
    if [[ -t 2 ]]; then
        echo $'\033[31m'"$@"$'\033[0m'
    else
        echo "$@"
    fi
    exit 1
}

# Handle command line options
while true; do
    case $1 in
        -f|--flush)
            DO_FLUSH=1
            shift
            ;;
        -*)
            echo "$USAGE"
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

[[ -n "$1" ]] || abort $USAGE
[[ "$EUID" -eq 0 ]] || abort "Must be run as root"

TARFILE=$1
[[ -f $TARFILE ]] || abort "$TARFILE doesn't exist"

cd /opt/workers
echo "Stopping workers..."
systemctl stop *worker@*.service || abort "Can't stop workers"

echo "Extracting $TARFILE..."
rm -fr .shiv
tar xvzf $TARFILE
chown pandex_worker_user:pandex_worker_user *.pyz

echo "Zapping worker logs..."
for log in $(ls /var/log/*worker.log); do
    echo $log
    cat /dev/null > $log
done

if [[ -n "$DO_FLUSH" ]]; then
    echo "Flushing Redis queues..."
    redis-cli -h $PDX_REDIS_HOST flushall
fi

echo "Restarting workers..."
systemctl --all start *worker@*.service

systemctl list-units *worker@* | grep @ | cut -d@ -f1 | uniq -c

exit 0
