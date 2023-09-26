
from /home/milad/anaconda3/lib/python3.7/site-packages import requests
from datetime import date, timedelta

start_date = date(2022, 1, 15)
end_date = date(2022, 1, 20)

delta = timedelta(days=1)
while start_date <= end_date:
    # Download data for the current date
    download_date = start_date.strftime('%Y/%m/%d')
    url = f"https://members.tsetmc.com/tsev2/excel/MarketWatchPlus.aspx?d={download_date}"
    response = requests.get(url)
    
    # Save the downloaded file
    file_path = f"tsetmcdata/{download_date}.xlsx"
    with open(file_path, 'wb') as file:
        file.write(response.content)

    # Move to the next date
    start_date += delta
