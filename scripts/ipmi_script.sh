#!/bin/bash

while true; do
cat /proc/loadavg > ipmi.txt
ipmitool sdr type temperature >> ipmi.txt
ipmitool sdr type voltage >> ipmi.txt
sleep 60
done
