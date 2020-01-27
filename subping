#!/bin/bash

###########################################################
# subping.sh - Subnet Ping Utility - v1.7 - Bill Atkinson #
###########################################################

#Global Variables
PREFIX=$1
CURRDIR=$(pwd)
OUTDIR=$(date +%m%d%Y_%H%M)
BASEDIR=~/subping
OUTPATH=$BASEDIR/$OUTDIR

#Functions
outpath() {
	if [ ! -d "$BASEDIR" ]; then
		mkdir $BASEDIR
		echo "Created base output directory: $BASEDIR"
		echo		
	fi
	
	if [ ! -d "$OUTPATH" ]; then
		mkdir $OUTPATH
		echo "Created output directory for this run: $OUTPATH"
		echo
	fi

	cd $OUTPATH
}

ip_list() {
        for LAST_OCTET in {2..254}; do
                ping -c 1 $PREFIX.$LAST_OCTET | grep "64 bytes" | awk ' { print $4 } ' | tr -d ":" >> $OUTPATH/ip_list.txt &
        done
        FOUND_IPS=$(wc -l < $OUTPATH/ip_list.txt)
        echo "Found $FOUND_IPS IP's."
        echo

}

ping_list() {
        for IP in $(cat $OUTPATH/ip_list.txt); do
                ping $IP | while read PONG; do echo "$(date): $PONG" >> $OUTPATH/$IP.txt; done &
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

plot() {
	if command -v gnuplot > /dev/null 2>&1; then
		shopt -s nullglob
		for FILE in $PREFIX*; do
			BASENAME=${FILE%.txt}
			awk '{print $4",",substr($13,6)}' $FILE > $BASENAME-times.txt
			gnuplot -e "set xdata time; set timefmt '%H:%M:%S'; set term png; set term png size 2048,786; set xtics rotate; set xtics 60; plot '$BASENAME-times.txt' using 1:2 with lines" > $BASENAME.png
		done
		echo "GNUPlot run complete."
		echo
	else
		echo "GNUPlot not installed.  No graphing possible."
		echo
	fi	
}

#Main
clear
if [ "$1" = "" ]; then
        echo "Usage: subping.sh [X.X.X] where X.X.X is the first three octects of the subnet to ping.  Example: ./subping.sh 192.168.1"
        echo
        exit 1
fi
outpath
ip_list
ping_list
stop_clean
plot
