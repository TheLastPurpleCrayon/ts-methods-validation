source("eacf_prelim.R")
library(googlesheets4)
library(hms)

url <- "https://docs.google.com/spreadsheets/d/1zw2tG0Hya0vnF6qJFGar3dfsipFrWSgVL0_L2DeWjGY/edit?usp=sharing"
sysname <- Sys.info()["nodename"] |> unname()
start_time <- Sys.time()
start_time.formatted <- format(start_time, "%Y-%m-%d %H:%M:%S")

# ask for nseries and Nsim
nseries <- as.numeric(readline("How many series?: "))
Nsim <- as.numeric(readline("How many bootstrap loops?: "))

start_printout <- paste0("EACF run\tTime:\t", start_time.formatted, 
                         "\tSeries Length:\t", nseries,
                         "\tNumber Bootstraps:\t", Nsim)
range_write(url, data = start_printout, range = "A1")
#range_write(url, data = results, range = "B1")

finish_time <- Sys.time()
finish_time.formatted <- format(finish_time, "%Y-%m-%d %H:%M:%S")
elapsed_time <- as_hms(finish_time - start_time) |> as.character() |> str_sub(1, 8)
final_printout <- paste0("Finished at:\t", finish_time.formatted,
                         "Time elapsed:\t", print(elapsed_time))
range_write(url, data = final_printout, range = "C1")