import pandas as pd
import os
import glob
import shutil

# Set the path to the folder where the Excel files are located
folder_path = "/home/milad/Option-Market/tsetmcdata"
# Use the glob module to get a list of all Excel files in the folder
file_paths = glob.glob(os.path.join(folder_path, "*.xlsx"))
merged_data = pd.DataFrame()
for file_path in file_paths:
    df = pd.read_excel(file_path, skiprows=1, header=1)

    # Perform any required edits to the DataFrame
    # df = df.iloc[1:]
    #add date culumns#
    df = df.replace({"ي": "ی", "ك": "ک"}, regex=True)


    # Get the original file name
    file_name = os.path.basename(file_path)
    # make date_name to add date column 
    date_name = file_name
    date_name = date_name.replace(".xlsx" , " ")
    df.insert(0, 'تاریخ', date_name.replace('-', '/'))
    # ????merged_data = merged_data.append(df)???
    output_path = "/home/milad/Option-Market/editedtsetmcdata"
    # Set the path to the new folder where the edited files will be saved
    edited_file_path = os.path.join(output_path, file_name)
    df.to_excel(edited_file_path, index=False)

print("All files have been saved to the new folder.")
