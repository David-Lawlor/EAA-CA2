#********************************************************************#
#                              runtest.sh                            #
#                       written by David Lawlor                      #
#                          December 15, 2016                         #
#                                                                    #
#          Perform load test on the cpu and output results           #
#	   to a file for anaysis                                     #
#********************************************************************#

#!/bin/bash

# Echo the column header to the results file
# Single > will overwrite any existing data in the file
# Data being collected for each iteration of the load test is 
# Number of users being simulated on the system (N)
# Number of transactions completed (Number_Completed_Transactions)
# The CPU idle percentage obtained via mpstat (CPU_Idle_Time_Percentage)
echo "C0	N	idle" > results.dat

echo -e "Starting system load test \n"

for i in {1..50}
do
	# An echo to signal the start of each load test
	echo "Starting Load Test $i"

	# Run the load test script with loop progress variable as 
	# the number of users input. The & will then put the process to the 
	# background which will enable the script to continue
	# $i is the loop progress variable which is used as the number of
	# system users input for the loadtest script
	./loadtest $i &

	# echo the pid of the load test process out to a file. This method of 
	# storing the process id is typically how the system keeps track of daemons 
	# running on the system
	echo $! > ./loadtest.pid

	# save the output in a variable 
	# 1 report at 10 second intervals
	# Average is awk'd and the last column of the line
	CPU_Idle_Time_Percentage=`mpstat 2 5 | awk '/Average/ { print $NF }'`

	# kill the load test process
	# the cat commmand will read the loadtest.pid which contains the process id
	# to be killed. The kill command will then issue the terminate signal to the 
	# process
	kill `cat ./loadtest.pid` 

	# The kill command above will issue the terminate signal to the process.
	# This sleep is to ensure that the load test process has completly terminated
	# and also terminated any child processed which may have spawned before 
	# continuing.
	sleep 1

	# count the number of completed processes
	# the wc -l counts the number of lines in the synthetic.dat file which is 
	# equal to the number of completed transations.
	# the < will output the number of completions without the filename which
	# is normally included in the output of wc -l when used on a file
	# this transaction completion count is stored in the C0 variable
	Number_Completed_Transactions=`wc -l < synthetic.dat`

	# output the load test results to file
	echo "$Number_Completed_Transactions	$i	$CPU_Idle_Time_Percentage" >> results.dat

	# An echo to signal the end of each load test
	echo -e "Completed Load Test $i \\n"
done

# An echo to signal the end of the entire load test
echo "System Load test completed"

# cleanup
rm ./loadtest.pid
rm ./synthetic.dat

# exit with exit code 0 for success
exit 0
