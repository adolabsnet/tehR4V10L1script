#!/bin/bash


# echo -e " $(cat myOutput-01.csv | grep -i zms |head -n1 | tail -n1 | awk '{print substr($6, 1, length($6)-1)}') "
victims_channel=$(cat /root/tehR4V10L1script/tmp/myOutput-01.csv | grep -i zms |head -n1 | tail -n1 | awk '{print substr($6, 1, length($6)-1)}')
echo -e "$victims_channel"

exit 0