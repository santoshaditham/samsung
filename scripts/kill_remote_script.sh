#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'

for i in {1..10}
do	
ssh root@10.250.3.$i bash -c "'
pkill participant 
'"
done

for i in {1..10}
do
ssh root@10.250.3.$i bash -c "'
pkill seller 
'"
done

ssh root@10.250.3.10 bash -c "'
pkill scheduler
kill $(ps aux | grep 'ipmi_script' | awk '{print $2}')
'"
