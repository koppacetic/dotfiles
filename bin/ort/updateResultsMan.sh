#!/bin/bash
USAGE="USAGE: updateResultsMan.sh <tarfile>"
OPTDIR="/opt/dart_results_manager"
SERVICE="dart_results_manager"
DART_USER="dart_results_user"
LOGFILE="/var/log/dart_results_manager.log"

abort () {
    if [[ -t 2 ]]; then
        echo $'\033[31m'"$@"$'\033[0m'
    else
        echo "$@"
    fi
    exit 1
}

[[ "$EUID" -eq 0 ]] || abort "Must be run as root"
[[ -n "$1" ]] || abort $USAGE

TARFILE=$1
[[ -f $TARFILE ]] || abort "$TARFILE doesn't exist"

cd $OPTDIR
echo "Stopping $SERVICE..."
systemctl stop $SERVICE || abort "Can't stop $SERVICE"

echo "Extracting $TARFILE..."
rm -fr .shiv
tar xvzf $TARFILE
chown ${DART_USER}:${DART_USER} *.pyz

echo "Running migrations..."
python3 $OPTDIR/results_manager.pyz --djenv .env makemigrations
python3 $OPTDIR/results_manager.pyz --djenv .env migrate

echo "Zapping $LOGFILE..."
cat /dev/null > $LOGFILE

echo "Restarting $SERVICE..."
systemctl start $SERVICE

systemctl status $SERVICE

exit 0

