suppressMessages(library(tidyverse))
suppressMessages(library(TSA))
library(parallelly)

# idea for end result: a matrix of proportions of the time the 
# eacf was correct in that position

simulate.arma11 <- function(nseries, Nsim, seed) {
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
  
  eacfQUIET <- quietly(eacf)
  
  out.matrix <- matrix(0, nrow = 8, ncol = 14)
  
  set.seed(seed)
  for (i in 1:Nsim){
    spec <- list(ar = runif(1, min = -1, max = 1), 
                 ma = runif(1, min = -1, max = 1))
    
    series <- arima.sim(model = spec, n = nseries)
    e <- eacfQUIET(series)$result
    
    for (row in 1:nrow(out.matrix)) {
      for (col in 1:ncol(out.matrix)) {
        if (theoretical[row, col] == e$symbol[row, col]) {
          out.matrix[row, col] <- out.matrix[row, col] + 1
        }
      }
    }
  }
  
  out.matrix <- out.matrix/Nsim
  as.data.frame(out.matrix)
}

# tic <- Sys.time()
# result <- simulate.arma11(nseries = 1000, Nsim = 1000, seed = factorial(10))
# toc <- Sys.time()
# toc-tic
# result





