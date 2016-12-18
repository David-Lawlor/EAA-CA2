# read in the data from the results file
# The results file contains:
# N = Number of users on the system
# C0 = the number of completed transactions
# idle = percentage of time the CPU spent idle(idle)

# read in the results file from the load test
results <- read.table('results.dat' , header = TRUE)

# store data from results file in variables with meanful names
number_of_completions_C0 <- results$C0
number_of_concurrent_users_N <- results$N
percentage_of_time_idle <- results$idle

# time the load test ran for
testtime = 10

# The output of mpstat is the percetage of time spent idle.
# Using this we can deduce 100 - percentage of time spent idle(idle) = Bi / T 
# results file contains percentage idle. 100 - percentage idle is percentage busy  
percentage_of_time_busy <- (100 - percentage_of_time_idle)

# utilisation is measured on 0 to 1 scale. busy / 100 will convert to this scale
utilisationCPU_Ui <- (percentage_of_time_busy / 100)

# X0: system throughput: X0 = C0 /T 
system_throughput_X0 <- number_of_completions_C0 / testtime

# Di = Ui / (C0 / T) 
service_demand_Di <- (utilisationCPU_Ui / system_throughput_X0)

# R = N / X0 (Little’s Law)
response_time_R = number_of_concurrent_users_N / system_throughput_X0

###

# Graph 1. Ui vs N - Plot graph for utilisation vs Number of users
# Ui : The utilisation of resource i.
# N = Number of concurrent users on the system

png(filename="Utilisation-VS-N.png", height=768, width=1366, bg="white")
plot(number_of_concurrent_users_N, utilisationCPU_Ui , type="l", col="blue", lty=5,
     ylab = 'Utilisation', xlab = 'Number of Concurrent Users', main = 'Utilisation Vs Number of Users' )

dev.off()

###

# Graph 2. Di vs N - Plot graph for service demand vs Number of concurrent users
# Di = Service Demand
# N = Number of concurrent users on the system

png(filename="ServiceDemand-VS-N.png", height=768, width=1366, bg="white")
plot(number_of_concurrent_users_N, service_demand_Di , type="l", col="blue", lty=5,
     ylab = 'Service Demand (seconds/request)', xlab = 'Number of Concurrent Users', main = 'Service Demand Vs Number of Users' )

dev.off()

###

# Graph 3. X0 vs N - Plot graph for system throughput vs Number of concurrent users
# X0 = System Throughput
# N = Number of concurrent users on the system

png(filename="System_Throughput-VS-N.png", height=768, width=1366, bg="white")
plot(number_of_concurrent_users_N, system_throughput_X0 , type="l", col="blue", lty=5,
     ylab = 'System Throughput (Transactions per second)' , xlab = 'Number of Concurrent Users', main = 'System Throughput Vs Number of Concurrent Users' )

dev.off()

###

# Graph 4. R vs N - Plot graph for system throughput vs Number of concurrent users
# R = System Response time
# N = Number of concurrent users on the system

png(filename="response_time-VS-N.png", height=768, width=1366, bg="white")
plot(number_of_concurrent_users_N, response_time_R , type="l", col="blue", lty=5,
     ylab = 'Response Time (Seconds)' , xlab = 'Number of Concurrent Users', main = 'Response Time Vs Number of Concurrent Users' )

dev.off()

