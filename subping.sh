#!/bin/bash

###########################################################
# subping.sh - Subnet Ping Utility - v1.4 - Bill Atkinson #
###########################################################

#Global Variables
PREFIX=$1
CURRDIR=$(pwd)

#Functions
pre_clean() {
        if [ -f "$CURRDIR/ip_list.txt" ]; then
                rm -fr $CURRDIR/ip_list.txt
        fi

        if [ ! -f "$CURRDIR/$PREFIX*" ]; then
                rm -fr $CURRDIR/$PREFIX*
        fi
}

ip_list() {
        for LAST_OCTET in {2..254}; do
                ping -c 1 $PREFIX.$LAST_OCTET | grep "64 bytes" | awk ' { print $4 } ' | tr -d ":" >> $CURRDIR/ip_list.txt &
        done
        FOUND_IPS=$(wc -l < $CURRDIR/ip_list.txt)
        echo "Found $FOUND_IPS IP's."
        echo

}

ping_list() {
        for IP in $(cat $CURRDIR/ip_list.txt); do
                ping $IP | while read PONG; do echo "$(date): $PONG" >> $CURRDIR/$IP.txt; done &
        done
        echo Spawning ping processes for each IP.
        echo
}

stop_clean() {
        read -p "Press [ENTER] to stop ping processes and clean output files...."
        echo
        killall ping > /dev/null 2>&1
        shopt -s nullglob
        for FILE in $PREFIX*; do
        sed -i '1d' $FILE
        done

        shopt -s nullglob
        for FILE in $PREFIX*; do
                tac "$FILE" > "${FILE}".tmp
                sed -i "1,4d" "${FILE}".tmp
                tac "${FILE}".tmp > "$FILE"
                rm -fr "${FILE}".tmp
        done
}

#Main
clear
if [ "$1" = "" ]; then
        echo "Usage: subping.sh [X.X.X] where X.X.X is the first three octects of the subnet to ping.  Example: ./subping.sh 192.168.1"
        echo
        exit 1
fi
pre_clean
ip_list
ping_list
stop_clean
