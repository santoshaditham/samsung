#!/bin/bash

echo '3c88202f44e969b892178acf6f600da0'
echo 'start scheduler'
ssh root@10.250.3.10 bash -c "'
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/Poco/lib
cd Admin/
nohup ./ipmi_script.sh > foo_ipmi.out 2> foo_ipmi.err < /dev/null &
pkill scheduler
nohup ./scheduler> foo.out 2> foo.err < /dev/null &
'"

echo 'start all nodes - sellers'
for i in {1..10}
do
DIRECTORY=("Seller")
ssh root@10.250.3.$i bash -c "'
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/Poco/lib 
if [[ -d "${DIRECTORY}" && ! -L "${DIRECTORY}" ]]; then 
cd ${DIRECTORY} 
nohup ./ipmi_script.sh > foo_ipmi.out 2> foo_ipmi.err < /dev/null &
pkill seller 
nohup ./seller > foo.out 2> foo.err < /dev/null &
fi
'"
done

echo 'start all nodes - participants'
for i in {1..10}
do	
DIRECTORY=("Participant")
ssh root@10.250.3.$i bash -c "'
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/Poco/lib 
if [[ -d "${DIRECTORY}" && ! -L "${DIRECTORY}" ]]; then 
	cd ${DIRECTORY} 
	nohup ./ipmi_script.sh > foo_ipmi.out 2> foo_ipmi.err < /dev/null &
	pkill participant 
	nohup ./participant > foo.out 2> foo.err < /dev/null &
fi
'"
done


#let all nodes become fully active and waiting
#sleep 4
