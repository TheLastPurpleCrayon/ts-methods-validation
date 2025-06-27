source("eacf_prelim.R")
library(googlesheets4)
suppressMessages(library(hms))

# args
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2 | !is.numeric(args[1]) | !is.numeric(args[2])) {
  print("Usage: Rscript eacf_prelim.R <series length> <num bootstrap loops>")
  stop()
}
nseries <- args[1]
Nsim <- args[2]

# initialize vars
url <- "https://docs.google.com/spreadsheets/d/1zw2tG0Hya0vnF6qJFGar3dfsipFrWSgVL0_L2DeWjGY/edit?usp=sharing"
sysname <- Sys.info()["nodename"] |> unname()
start_time <- Sys.time()
start_time.formatted <- format(start_time, "%Y-%m-%d %H:%M:%S")

output_row <- 1
results <- matrix(nrow = 1)

start_printout <- c("EACF run", 
                    "Time:", start_time.formatted, 
                    "System:", sysname, 
                    "Series Length:", nseries,
                    "Number Bootstraps:", Nsim) |> matrix() |> t() |> as.data.frame()

# start writing to the sheet
range_write(url, data = start_printout, range = paste0("A", output_row), col_names = F)
output_row <- output_row + 1

# do the simulation!
results <- simulate.arma11(nseries, Nsim, seed = factorial(10))
range_write(url, data = results, range = paste0("A", output_row), col_names = F)
output_row <- output_row + nrow(results)

# write the final output
finish_time <- Sys.time()
finish_time.formatted <- format(finish_time, "%Y-%m-%d %H:%M:%S")
elapsed_time <- as_hms(finish_time - start_time) |> as.character() |> str_sub(1, 8)
final_printout <- c("Finished at:", finish_time.formatted,
                    "Time elapsed:", elapsed_time) |> matrix() |> t() |> as.data.frame()
range_write(url, data = final_printout, range = paste0("A", output_row), col_names = F)