
library(dplyr)
library(furrr)
library(future)
library(purrr)
library(stringr)
library(tibble)

# set up furrr multiprocess
future::plan(multiprocess)

# Minors ------------------------------------------------------------------

minors <- c("FPMN", "PTI", "FCWN", "PRBN", "FRBN",
            "PAGN", "CUST", "FAGN", "FCM", "FFH",
            "GL", "PPMN", "PCAG", "FCWD", "FLMR",
            "RS", "PCPM", "HIGH", "FLAG", "FCSR",
            "MAST", "FFI", "PPBN", "FPBN", "PCPB",
            "PCRL", "FTI", "FLPM", "CUSL", "FLSC",
            "PFH", "FMRP", "HIGN", "FLRL", "INVN",
            "PFRB", "FLPB", "PCSR", "FFRB", "FRLN")



# Read file ---------------------------------------------------------------

raw <- readLines("C:/users/lindblb/desktop/CM_TRIAL.VUL")

lines <- raw[38:270184]



# Function to pull all customer data --------------------------------------

getData <- function(index) {
  #
  # Inputs
  #  lines (global): char vec of lines to parse from
  #  index: the starting point in lines
  # Returns tibble
  #

  index = cust_starts[1]

  end <- index + 4

  namo <- substr(lines, 1, 22)
  meat <- substr(lines, 23, length(lines))

  mydata <- read.table(text = meat[index:end], fill = T, stringsAsFactors=FALSE)
  mydatas <- tibble::tibble(j= meat[index:end])



  # parse indiv elements
  final <- tibble::tibble(name = namo[index],
                          account_number = namo[index + 1],
                          int_rate = substr(mydatas$j[1], 13,20),
                          cont_date = substr(mydatas$j[1], 23,33),
                          orig_amount = substr(mydatas$j[1], 35,49),
                          accr_int = substr(mydatas$j[1], 51,64),
                          due_date = substr(mydatas$j[1], 66,76),

                          rate_type = substr(mydatas$j[2], 10,20),
                          prin_bal = substr(mydatas$j[2], 34,49),
                          owned_amt = substr(mydatas$j[2], 99,113),

                          ytd_int = substr(mydatas$j[3], 34,49),
                          sold_amt = substr(mydatas$j[3], 99,113),

                          credit_limit = substr(mydatas$j[4], 13,27),
                          avail_credit = substr(mydatas$j[4], 50,64)
                          )

  return(final)

}

getData <- purrr::possibly(getData, otherwise = NULL)

# Find cust_starts --------------------------------------------------------

cust_starts <- lines

fnX <- function(x) ifelse(test = stringr::str_detect(x, paste(minors, collapse = '|')), "start", "not")

foo <- purrr::map(lines, fnX)

names(cust_starts) <- foo

# find the index of all cust_starts
cust_starts <- which(names(cust_starts) %in% "start")



# Combine -----------------------------------------------------------------

results <- furrr::future_map(.x = cust_starts, .f = getData, .progress = T)


final.results <- dplyr::bind_rows(results, .id = "id")

# for some reason, there are messed up rows, can confirm no records are being skipped...
#   removing them here

final.results <- final.results %>%
  dplyr::mutate(name = trimws(name)) %>%
  dplyr::filter(name != "") %>%
  dplyr::filter(name != "(Part)")

# Save --------------------------------------------------------------------

write.csv(final.results, "c:/users/lindblb/desktop/vul_parsed.csv")


