suppressMessages(library(tidyverse))
suppressMessages(library(TSA))
library(parallelly)

# idea for end result: a matrix of proportions of the time the 
# eacf was correct in that position

simulate.arma11 <- function(nseries, Nsim, seed) {
  # hard code the theoretical eacf for an ARMA(1, 1) process
  theoretical <- matrix(
    c(rep("x", 14),
      rep("x", 1), rep("o", 13),
      rep("x", 2), rep("o", 12),
      rep("x", 3), rep("o", 11),
      rep("x", 4), rep("o", 10),
      rep("x", 5), rep("o", 9),
      rep("x", 6), rep("o", 8),
      rep("x", 7), rep("o", 7)),
    ncol = 14, nrow = 8, byrow = T, dimnames = list(0:7, 0:13)
  )
  
  # suppress automatic printing
  eacfQUIET <- quietly(eacf)

  # initialize variables
  out.matrix <- matrix(0, nrow = 8, ncol = 14) # start with an output matrix of all 0's
  empirical <- matrix(NA, nrow = 8, ncol = 14)
  spec <- list(ar = NA, ma = NA)
  series <- numeric(nseries)
  
  set.seed(seed)
  for (i in 1:Nsim){
    # generate random values for the AR and MA terms
    spec$ar[] <- runif(1, min = -1, max = 1)
    spec$ma[] <- runif(1, min = -1, max = 1)
    
    # generate a series based on the random coefficients and compute its eacf
    series[] <- arima.sim(model = spec, n = nseries)
    empirical[] <- eacfQUIET(series)$result$symbol
    
    # if the empirical values match the theoretical, increment that position in out.matrix
    out.matrix[] <- out.matrix + (theoretical == empirical)
    
    # run garbage collection every 1000 iterations
    if (i %% 1000 == 0) gc()
  }
  
  out.matrix <- out.matrix/Nsim
  as.data.frame(out.matrix)
}

# 21 almost identical to 11
simulate.arma21 <- function(nseries, Nsim, seed) {
  theoretical <- matrix( # changed
    c(rep("x", 14),
      rep("x", 14),
      rep("x", 1), rep("o", 13),
      rep("x", 2), rep("o", 12),
      rep("x", 3), rep("o", 11),
      rep("x", 4), rep("o", 10),
      rep("x", 5), rep("o", 9),
      rep("x", 6), rep("o", 8)),
    ncol = 14, nrow = 8, byrow = T, dimnames = list(0:7, 0:13)
  )
  eacfQUIET <- quietly(eacf)
  
  out.matrix <- matrix(0, nrow = 8, ncol = 14)
  empirical <- matrix(NA, nrow = 8, ncol = 14)
  spec <- list(ar = rep(NA, 2), ma = NA) # changed
  series <- numeric(nseries)
  
  set.seed(seed)
  for (i in 1:Nsim){
    spec$ar[] <- runif(2, min = -1, max = 1) # changed
    spec$ma[] <- runif(1, min = -1, max = 1)
    
    series[] <- arima.sim(model = spec, n = nseries)
    empirical[] <- eacfQUIET(series)$result$symbol
    
    out.matrix[] <- out.matrix + (theoretical == empirical)
    
    if (i %% 1000 == 0) gc()
  }
  out.matrix <- out.matrix/Nsim
  as.data.frame(out.matrix)
}


