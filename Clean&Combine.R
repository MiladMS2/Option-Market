
# Cleaning Function -------------------------------------------------------

# Reading and cleaning first rows
tsetmc_cleaner <- function(file_date){
#filepath <- paste("~/Option-Market/tsetmcdata/",file_date,".xlsx",sep  = "")
x <- suppressMessages( read_excel(file_date,skip = 1,))
names(x) <- x[1,]
x <- x[-1,] %>% mutate(date=file_date %>% as_date()) %>% relocate(date) #%>% mutate_all(type.convert)
return(x)}

# Combining Function -------------------------------------------------------
# Combining the files
tsetmc_combiner <- function(file_list) {
  pattern <- paste0("^(", paste(file_list, collapse = "|"), ")")
  files <- list.files("~/Option-Market/", pattern =pattern,recursive = TRUE,full.names = TRUE)
  return(map(files,.f = tsetmc_cleaner , .progress = TRUE) %>% bind_rows())
}

