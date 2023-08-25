# Cleaning Function -------------------------------------------------------
# Reading and cleaning first row,add date to 1st column
tsetmc_cleaner <- function(file_date) {
  pattern <- paste0("^(", file_date, ")")
  files <- list.files("~/Option-Market/", pattern = pattern, recursive = TRUE, full.names = TRUE)
  x <- suppressMessages(read_excel(files, skip = 1, ))
  names(x) <- x[1, ]
  x <- x[-1, ] %>%
    mutate(date = file_date %>% as_date()) %>%
    relocate(date) %>%
    mutate(across(everything(), ~ type.convert(.x, as.is = TRUE))) %>%
    mutate(across(where(is.character), ~ str_replace_all(.x, c("ك" = "ک", "ي" = "ی"))))

  return(x)
}

# Combining Function -------------------------------------------------------
# Combining the files
tsetmc_combiner <- function(file_list) {
  # pattern <- paste0("^(", paste(file_list, collapse = "|"), ")")
  # files <- list.files("~/Option-Market/", pattern =pattern,recursive = TRUE,full.names = TRUE)
  return(map_dfr(file_list, .f = tsetmc_cleaner, .progress = TRUE) %>% bind_rows())
}


# Option_trades -----------------------------------------------------------

# Find option trades
x <- tsetmc_combiner("1402-05-31")
