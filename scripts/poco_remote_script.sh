#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'
i=1
while [ $i -lt 10 ]
do
	ssh root@10.250.3.$i 'cd Poco && ./configure --omit=NetSSL_OpenSSL,Crypto,Data/ODBC,Data/MySQL && gmake -s && sudo gmake -s install && exit'
i=$[$i+1]
done
