#!/bin/sh
endDate=$(date +"%d-%m-%y:%H:%M:%S")
startDate=$(date +"%d-%m-%y:%H:%M:%S" --date='5 min ago')
echo "start Date $startDate"
echo "end Date $endDate"
awk -v sD="$startDate" -v eD="$endDate" ' $1>=sD && $1<=eD  ' other_vhosts_access.log > /var/log/apache2/test

