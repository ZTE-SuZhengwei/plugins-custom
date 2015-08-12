#!/bin/bash
#
# Disk health monitoring script 
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

STATE=$STATE_OK
STATE_INFO="Disk Smart Check Result:"
usage ()
{
    echo "Usage: $0 [OPTIONS]"
    echo " -h			Get help"
}

if ! which smartctl >/dev/null 2>&1
then
    echo "smartmontools is not installed."
    exit $STATE_UNKNOWN
fi



get_disk_device() {
    ls /dev/ | egrep 'sd[a-z]$|hd[a-z]$' 
}


check_disk_status() {
    DISK_INFO=$(sudo smartctl  -H  /dev/$1 2>/dev/null | grep "test result" 2>/dev/null)
    DISK_HEALTH=${DISK_INFO##*:}
    echo $DISK_HEALTH
}

for disk in `get_disk_device`; do
    disk_status=`echo $(check_disk_status $disk)`
    if  [ "$disk_status" != "OK" ] && [ "$disk_status" != "PASSED" ]; then        
        STATE=$STATE_WARNING
    fi
    STATE_INFO=$STATE_INFO"[$disk,$disk_status]"
done

echo $STATE_INFO
exit $STATE