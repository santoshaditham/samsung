#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'
i=1
while [ $i -lt 11 ]
do
ssh root@10.250.3.$i 'rm *.tar.gz && exit'
if [ $i -ne 10 ]
then
	if [ $i -eq 1 -o $i -eq 4 -o $i -eq 7 ]
	then
		cd Seller
		make clean
		cd ..
		rm Seller.tar.gz
		tar -zcf Seller.tar.gz Seller/
		scp /home/s/saditham/Seller.tar.gz root@10.250.3.$i:~/
	else
		cd Participant
		make clean
		cd ..
		rm Participant.tar.gz
		tar -zcf Participant.tar.gz Participant/
		scp /home/s/saditham/Participant.tar.gz root@10.250.3.$i:~/
	fi
else
	cd Admin
	make clean
	cd ..
	rm Admin.tar.gz
	tar -zcf Admin.tar.gz Admin/
	scp /home/s/saditham/Admin.tar.gz root@10.250.3.$i:~/
fi
i=$[$i+1]
done
