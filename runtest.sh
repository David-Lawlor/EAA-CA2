#!/bin/bash
echo "CO	N	idle" > results.dat

for i in {1..50}
do
	echo "Starting Load Test $i"

	# Running the load test
	./loadtest $i &

	# echo the pid of the load test out to a file
	echo $! > ./loadtest.pid

	# save the output in a variable 
	# 5 reports at 2 second intervals
	# Average is awk'd and the last column of the line
	Ucpu=`mpstat 2 5 | awk '/Average/ { print $NF }'`

	# kill the load test process
	kill `cat ./loadtest.pid` 

	# count the number of completed processes
	CO=`wc -l < synthetic.dat`

	# output the load test results to file
	echo "$i	$CO	$Ucpu" >> results.dat
done


echo "Finished"