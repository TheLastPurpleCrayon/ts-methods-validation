source("eacf_prelim.R")
library(googlesheets4)
suppressMessages(library(hms))

# args
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 3) {
  stop("Usage: Rscript simulation.R <pq> <series length> <num bootstrap loops>")
}
mode <- args[1]
nseries <- as.numeric(args[2])
Nsim <- as.numeric(args[3])

# authorize access to the google sheet
gs4_auth(email = read_file("../antiscrape/email.txt") |> str_replace("\n", ""))

# initialize vars
url <- read_file("../antiscrape.ts_sheet.txt") |> str_replace("\n", "")
sysname <- Sys.info()["nodename"] |> unname()
start_time <- Sys.time()
start_time.formatted <- format(start_time, "%Y-%m-%d %H:%M:%S")

output_row <- 1
results <- matrix(nrow = 1)

start_printout <- c(paste0("ARMA(", substr(mode, 1, 1), ", ", substr(mode, 2, 2), ")"), 
                    "Time:", start_time.formatted, 
                    "System:", sysname, 
                    "Series Length:", nseries,
                    "Number Bootstraps:", Nsim) |> matrix() |> t() |> as.data.frame()

# start writing to the sheet
range_write(url, data = start_printout, range = paste0("A", output_row), col_names = F, sheet = sysname)
output_row <- output_row + 1

# do the simulation!
if (mode == "11") {
  results <- simulate.arma11(nseries, Nsim, seed = factorial(10))
} else if (mode == "21") {
  results <- simulate.arma21(nseries, Nsim, seed = factorial(10))
} else {
  stop("Invalid mode :( Currently implemented modes are 11 and 21")
}

range_write(url, data = results, range = paste0("A", output_row), col_names = F, sheet = sysname)
output_row <- output_row + nrow(results)

# write the final output
finish_time <- Sys.time()
finish_time.formatted <- format(finish_time, "%Y-%m-%d %H:%M:%S")
elapsed_time <- as_hms(finish_time - start_time) |> as.character() |> str_sub(1, 8)
final_printout <- c("Finished at:", finish_time.formatted,
                    "Time elapsed:", elapsed_time) |> matrix() |> t() |> as.data.frame()
range_write(url, data = final_printout, range = paste0("A", output_row), col_names = F, sheet = sysname)