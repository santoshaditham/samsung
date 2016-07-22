#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'
i=1
while [ $i -lt 11 ]
do
scp /home/s/saditham/.ssh/id_rsa.pub root@10.250.3.$i:~/.ssh/authorized_keys
i=$[$i+1]
done
