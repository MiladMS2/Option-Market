# install.packages("tidyverse")
library(tidyverse)
library(readxl)
library(httr)
library(lubridate)
# Get the historical market data ----------------------------------------------------

# Set the dates
Start_date <- today()
End_date <- as_date("2023/08/15")
dates <- seq.Date(today(),End_date,by="-1 days")

# Read the data from TSETMC
for (date in dates) {
  output_path <- paste("~/tmp/", gsub("/", "-", date), ".xlsx", sep = "")
  
  # Check if the file exists before downloading
  if (!file.exists(output_path)) {
    file_url <- paste('https://members.tsetmc.com/tsev2/excel/MarketWatchPlus.aspx?d=', date, sep = "")
    GET(url = file_url,write_disk(path = output_path))
    
  } else {
    cat("File already exists:", date, "\n")
  }
}



#market_hist <- read_xlsx(path = "~/tmp/1402-05-25.xlsx")

