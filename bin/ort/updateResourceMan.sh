#!/bin/bash
USAGE="USAGE: updateResourceMan.sh <tarfile>"
OPTDIR="/opt/dart_resource_manager"
SERVICE="dart_resource_manager"
DART_USER="resource_user"
LOGFILE="/var/log/dart_resource_manager.log"

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
python3 $OPTDIR/resource_manager.pyz --djenv .env makemigrations
python3 $OPTDIR/resource_manager.pyz --djenv .env migrate

echo "Zapping $LOGFILE..."
cat /dev/null > $LOGFILE

echo "Restarting $SERVICE..."
systemctl start $SERVICE

systemctl status $SERVICE

exit 0

