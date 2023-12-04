#!/bin/bash
USAGE="USAGE: updateCloningAPI.sh <tarfile>"
LOGFILE="/var/log/cloning_api.log"

if [[ -z "$1" ]]; then
	echo $USAGE
	exit 1
fi

# Untar the cloning API file
tar xvzf $1

# Stop the cloning_api service
systemctl stop cloning_api.service

# Move the new API into place
mv cloning_api /opt/cloning_api/

# Zap the log file
cat /dev/null > $LOGFILE

# Start the cloning_api service
systemctl start cloning_api.service

# Show status
systemctl status cloning_api.service

