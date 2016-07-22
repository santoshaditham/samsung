#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'
i=2
while [ $i -lt 10 ]
do
scp /home/s/saditham/$1 root@10.250.3.$i:~/$1
i=$[$i+1]
done
