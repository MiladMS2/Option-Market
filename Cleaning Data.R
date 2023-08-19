
# Cleaning Function -------------------------------------------------------

x <- read_excel("~/tmp/1402-05-25.xlsx")

#data_frames <- map(file_path, ~read_excel(.x))
# x <- x %>% drop_na()
# x <- x %>% `colnames<-`(x[1,])
x <- row_to_names(x,row_number = 2,remove_row = TRUE,remove_rows_above = TRUE)
