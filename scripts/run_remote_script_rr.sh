#!/bin/bash
echo '3c88202f44e969b892178acf6f600da0'
echo 'start admin'
DIRECTORY=("rr")
ssh root@10.250.3.10 bash -c "'
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/Poco/lib 
if [[ -d "${DIRECTORY}" && ! -L "${DIRECTORY}" ]]; then 
	cd ${DIRECTORY} 
	nohup ./ipmi_script.sh > foo_ipmi.out 2> foo_ipmi.err < /dev/null &
	pkill rr
	> foo.out
	nohup ./rr > foo.out 2> foo.err < /dev/null &
fi
'"


sleep 3

echo 'start all nodes'
for i in {1..9}
do	
DIRECTORY=("rr")
ssh root@10.250.3.$i bash -c "'
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/Poco/lib 
if [[ -d "${DIRECTORY}" && ! -L "${DIRECTORY}" ]]; then 
	cd ${DIRECTORY} 
	nohup ./ipmi_script.sh > foo_ipmi.out 2> foo_ipmi.err < /dev/null &
	pkill rr
	> foo.out
	nohup ./rr > foo.out 2> foo.err < /dev/null &
fi
'"
done

sleep 1

