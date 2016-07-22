#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'

: <<'END'
i=1
while [ $i -lt 11 ]
do
if [ $i -ne 10 ]
then
	if [ $i -eq 1 -o $i -eq 4 -o $i -eq 7 ]
	then
		ssh root@10.250.3.$i 'cd Seller/ && make && echo $USER && exit'
	else
		ssh root@10.250.3.$i 'cd Participant/ && make && echo $USER && exit'
	fi
else
	ssh root@10.250.3.$i 'cd Admin/ && make && echo $USER && exit'
fi
i=$[$i+1]
done
END

i=2
while [ $i -lt 10 ]
do
	ssh root@10.250.3.$i 'tar -xzvf rr.tar.gz && cd rr/ && make && echo $USER && exit'
i=$[$i+1]
done

