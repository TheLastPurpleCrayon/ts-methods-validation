source("eacf_prelim.R")
library(googlesheets4)
suppressMessages(library(hms))

url <- "https://docs.google.com/spreadsheets/d/1zw2tG0Hya0vnF6qJFGar3dfsipFrWSgVL0_L2DeWjGY/edit?usp=sharing"
sysname <- Sys.info()["nodename"] |> unname()
start_time <- Sys.time()
start_time.formatted <- format(start_time, "%Y-%m-%d %H:%M:%S")

# ask for nseries and Nsim
nseries <- as.numeric(readline("How many series?: "))
Nsim <- as.numeric(readline("How many bootstrap loops?: "))

start_printout <- c("EACF run", 
                    "Time:", start_time.formatted, 
                    "System:", sysname, 
                    "Series Length:", nseries,
                    "Number Bootstraps:", Nsim) |> matrix() |> t() |> as.data.frame()
range_write(url, data = start_printout, range = "A1")
#range_write(url, data = results, range = "B1")

finish_time <- Sys.time()
finish_time.formatted <- format(finish_time, "%Y-%m-%d %H:%M:%S")
elapsed_time <- as_hms(finish_time - start_time) |> as.character() |> str_sub(1, 8)
final_printout <- c("Finished at:", finish_time.formatted,
                    "Time elapsed:", print(elapsed_time)) |> matrix() |> t() |> as.data.frame()
range_write(url, data = final_printout, range = "C1")