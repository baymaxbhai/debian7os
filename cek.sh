#!/bin/bash

#

# Copyright by baYmaxBhai_ssh@vpn

# ========================

#

data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

echo "Checking user login";

echo "---";

for PID in "${data[@]}"

do

#echo "check $PID";

NUM=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep $PID | wc -l`;

USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep $PID | awk '{print $10}'`;

IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep $PID | awk '{print $12}'`;

if [ $NUM -eq 1 ]; then

echo "$PID - $USER - $IP";

fi

done

echo "---";

echo "baYmaxBhai_ssh@vpn";

