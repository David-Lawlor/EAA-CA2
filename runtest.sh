#!/bin/bash

for i in {1..2}
do
	echo "Starting Load Test $i"
	./loadtest $i &
	echo $! > ./loadtest.pid

	mpstat 2 5 | awk '/Average/ { print $NF }'

	kill `cat ./loadtest.pid`
done

echo "Finished"