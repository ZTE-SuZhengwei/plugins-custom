#!/bin/bash
#
# MariaDB Service status monitoring script 
#
# Author: suzhengwei
#
# 

set -e

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4


usage ()
{
    echo "Usage: $0 [OPTIONS]"
    echo " -h               Get help"
    echo "No parameter : Just run the script"
}

while getopts 'h:H:' OPTION
do
    case $OPTION in
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done


if ! KEY=$(systemctl list-units --type=service | grep mariadb)
then
    echo "CRITICAL - MariaDB service is dead."
    exit $STATE_CRITICAL
fi

STATUS=$(mysqladmin -uroot -proot status)
echo "OK - MariaDB service is running-$STATUS "
exit $STATE_OK
