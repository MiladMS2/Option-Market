x <- tsetmc_combiner("1402-05-31")

y <- x %>%
  filter(grepl("اختیار", نام)) %>%
  select(c("date", "نماد", "نام", "ارزش", "آخرین معامله - مقدار", "قیمت پایانی - مقدار")) %>%
  clean_names() %>%
  mutate(
    option_type = sub("^(اختیار[فخ]) .*", "\\1", nam, perl = TRUE), .after = date,
    # nam = sub("^اختیار[فخ] ", "", nam),
    K = as.numeric(sub("^.*-(\\d+)-.*", "\\1", nam)),
    UA=str_extract(nam,"\\s(.*?)-",group = 1),
    Exp_date=str_extract(nam,"(?<=-)[^-]+$")
  )
