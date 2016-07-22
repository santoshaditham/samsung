#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'
filename=$1
participants=(1 2 10)
for i in "${participants[@]}"
do
	scp root@10.250.3.$i:~/Participant.tar.gz ~/tars/
	scp root@10.250.3.$i:~/rr-participant.tar.gz ~/tars/
	scp root@10.250.3.$i:~/Seller.tar.gz ~/tars/
	scp root@10.250.3.$i:~/rr-seller.tar.gz ~/tars/
	scp root@10.250.3.$i:~/Admin.tar.gz ~/tars/
	scp root@10.250.3.$i:~/rr.tar.gz ~/tars/
done
