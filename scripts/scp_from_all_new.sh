#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'
filename=$1
participants=( 1 2 3 4 5 6 7 8 9)
for i in "${participants[@]}"
do
	ssh root@10.250.3.$i "cd Participant && cp foo.out foo_$i.out"
	scp root@10.250.3.$i:~/Participant/foo_$i.out ~/outputs/
done
for i in "${participants[@]}"
do
	ssh root@10.250.3.$i "cd Seller && cp foo.out foo_$i.out"
	scp root@10.250.3.$i:~/Seller/foo_$i.out ~/outputs/
done

