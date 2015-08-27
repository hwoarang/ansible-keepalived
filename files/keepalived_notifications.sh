#!/bin/bash

TYPE=$1
NAME=$2
NEWSTATE=$3
OLDSTATE=$(cat /var/run/keepalived.state)

echo "Changed state from (probably) $OLDSTATE to $NEWSTATE" >> /var/log/keepalived-states.log

echo "$NEWSTATE" > /var/run/keepalived.state

if [ "$OLDSTATE" -ne "FAULT" ]
case $NEWSTATE in
        "MASTER") service haproxy start
                  exit 0
                  ;;
        "BACKUP") service haproxy stop
                  exit 0
                  ;;
        "FAULT") service haproxy stop
                 exit 0
                 ;;
        *) echo "unknown state"
           exit 1
           ;;

esac
else
#If something was faulty, try to get standard behaviour first.
echo "This could happen if your keepalived process ungracefully fails" >> /var/log/keepalived-states.log
case $NEWSTATE in
        "MASTER") service haproxy start
           service keepalived restart
           exit 0
           ;;
        "BACKUP") service haproxy start
           service keepalived restart
           exit 0
           ;;
        "FAULT") service haproxy start
                 exit 0
                 ;;
        *) echo "unknown state"
           exit 1
           ;;
esac
fi