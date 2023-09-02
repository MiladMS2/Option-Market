install.packages(c("tidyverse","readxl"))
require(tidyverse)
library(tidyverse)
library(readxl)
library(httr)
library(lubridate)
# Get the historical market data ----------------------------------------------------

# Set the dates
Start_date <- today()
End_date <- "2023/08/22" %>% as_date()
dates <- seq.Date(Start_date, End_date, by = "-1 days") %>% sapply(m2s)

# Read the data from TSETMC
for (date in dates) {
  # Replace slashes with hyphens in the date
  date_for_path <- gsub("/", "-", date)

  output_path <- paste("~/Option-Market/tsetmcdata/", date_for_path, ".xlsx", sep = "")

  # Check if the file exists before downloading
  if (!file.exists(output_path)) {
    file_url <- paste("https://members.tsetmc.com/tsev2/excel/MarketWatchPlus.aspx?d=", date, sep = "")
    GET(url = file_url, write_disk(path = output_path))
  } else {
    cat("File already exists:", date, "\n")
  }
}
