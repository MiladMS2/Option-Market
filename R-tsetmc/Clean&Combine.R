require(janitor)

# Cleaning Function -------------------------------------------------------
# Reading and cleaning first row,add date to 1st column
tsetmc_cleaner <- function(file_date) {
  pattern <- paste0("^(", file_date, ")")
  files <- list.files("~/Option-Market/", pattern = pattern, recursive = TRUE, full.names = TRUE) # nolint
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
  return(map_dfr(file_list, .f = tsetmc_cleaner, .progress = TRUE) %>% bind_rows())
}


# Option_trades -----------------------------------------------------------

tsetmc_option <- function(file_date) {
  x <- tsetmc_combiner(file_date) %>%
    # Find option trades
    filter(grepl("اختیار", نام)) %>%
    # Select the needed cols
    select(c("date", "نماد", "نام", "ارزش", "آخرین معامله - مقدار", "قیمت پایانی - مقدار")) %>%
    clean_names() %>%
    # Add K,UA,EXP_date cols
    mutate(
      option_type = sub("^(اختیار[فخ]) .*", "\\1", nam, perl = TRUE), .after = date,
      K = as.numeric(sub("^.*-(\\d+)-.*", "\\1", nam)),
      UA = str_extract(nam, "\\s(.*?)-", group = 1),
      Exp_date = str_extract(nam, "(?<=-)[^-]+$") %>%
        str_remove_all("/") %>%
        str_sub(-6)
    ) %>%
    mutate(Exp_date = paste0("1402-", substring(Exp_date, 3, 4), "-", substring(Exp_date, 5, 6)))
  return(x)
}
