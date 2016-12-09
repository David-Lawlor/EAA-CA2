perfdata <- 
  read.table('week10.dat',
             header=TRUE)

avgidle <- mean(perfdata$X.idle)
avgutil <- mean (100-prefdata$X.idle)


# R syntax for a function

calcAvgUtil <- function(idledata){
  avgutil <- mean (100-idledata)
}

# compute the service demand

source('~/Desktop/R lab/week10.dat')


totalTime <- 3600
completions <- 10000
X0 = completions / totalTime


calcSD <- function (){
  Dcpu <- avgutil / X0
    
}

print(calcSD())

print calcAvgUtil(perfdata$X.idle)