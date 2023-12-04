#!/bin/bash
# Runs the same testplan as different users
USAGE="multiuser.sh <my_dart_user> [testplan]"
TESTPLAN="skipSleep"
TEST_USERS="incy-tester tester2 tester3"
DART_USER=

abort() {
    echo $1
    exit 1
}

if [[ -z "$1" ]]; then
    abort "$USAGE"
fi
DART_USER=$1

if [[ -n "$2" ]]; then
    TESTPLAN=$2
fi

for user in $TEST_USERS; do
    if [[ $user == "incy-tester" ]]; then
        password="45-panama-ENERGY-able-49"
    else
        password="dartadmin"
    fi
    echo "======== Running $TESTPLAN as $user"
    dart_cli login $user -p $password || abort "Login failed"
    dart_cli cert download ./dart_config || abort "Cert download failed"
    dart_cli submit plans.$TESTPLAN || abort "Submit failed"
done

echo "======== Running $TESTPLAN as $DART_USER"
dart_cli login $DART_USER || abort "Login failed"
dart_cli cert download ./dart_config || abort "Cert download failed"
dart_cli submit plans.$TESTPLAN || abort "Submit failed"

exit 0
