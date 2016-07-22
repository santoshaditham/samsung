#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'

for i in {1..10}
do	
ssh root@10.250.3.$i "sudo reboot"
done
