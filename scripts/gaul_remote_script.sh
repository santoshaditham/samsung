#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'
i=1
while [ $i -lt 10 ]
do
	ssh root@10.250.3.$i 'wget "http://downloads.sourceforge.net/project/gaul/gaul-devel/0.1849/gaul-devel-0.1849-0.tar.gz" && tar -xzvf gaul-devel-0.1849-0.tar.gz && cd gaul-devel-0.1849-0/ && ./configure --enable-slang=no && make && sudo make install && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib" >> .bashrc && exit'

	#add linkers -lgaul -lgaul_util -lm to makefile
	#wget "http://sourceforge.net/projects/gaul/files/gaul-examples/0.1849/gaul-examples-0.1849-0.tar.gz"
	i=$[$i+1]
done
