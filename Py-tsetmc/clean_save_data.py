import pandas as pd
import os
import glob
import shutil

# Set the path to the folder where the Excel files are located
folder_path = "/home/milad/Option-Market/tsetmcdata"
# Use the glob module to get a list of all Excel files in the folder
file_paths = glob.glob(os.path.join(folder_path, "*.xlsx"))
merged_data = pd.DataFrame()
# for file_path in file_paths:
#     df = pd.read_excel(file_path, skiprows=1, header=1)

#     # Perform any required edits to the DataFrame
#     # df = df.iloc[1:]
#     #add date culumns#
#     df = df.replace({"ي": "ی", "ك": "ک"}, regex=True)


#     # Get the original file name
#     file_name = os.path.basename(file_path)
#     # make date_name to add date column 
#     date_name = file_name
#     date_name = date_name.replace(".xlsx" , " ")
#     df.insert(0, 'تاریخ', date_name.replace('-', '/'))
#     # ????merged_data = merged_data.append(df)???
#     output_path = "/home/milad/Option-Market/editedtsetmcdata"
#     # Set the path to the new folder where the edited files will be saved
#     edited_file_path = os.path.join(output_path, file_name)
#     df.to_excel(edited_file_path, index=False)

print("All files have been saved to the new folder.")
# combine and export data 
path = r'/home/milad/Option-Market/editedtsetmcdata'
all_files = glob.glob(path + "/*.xlsx")
li = []

for filename in all_files:
    df = pd.read_excel(filename)
    li.append(df)

df_combined = pd.concat(li, axis=0, ignore_index=True)


# Save the combined DataFrame to a new Excel file
#df_combined.to_excel('combined_data.xlsx', index=False)
print("combined excel has been saved.")
#filters for specific stocks and groups
option_df = df_combined[df_combined.iloc[:, 2].str.contains('اختیار')]
option_df=option_df[~option_df['نماد'].str.startswith("ه")]
# seprating the third column
option_df.insert(3, 'نام اختیار', '')
option_df.insert(4, 'اعمال', '')
option_df.insert(5, 'سررسید', '')
option_df[['نام اختیار', 'اعمال', 'سررسید']] = option_df['نام'].str.split('-', expand=True)
# define the type of contract
# def assign_value(symbol):
#     if symbol.startswith('ض'):
#         return 'خرید'
#     else:
#         return 'فروش'
# option_df.insert(6, 'نوع', '')
# option_df[['نوع']] = option_df['نام'].str.split('-', expand=True)
#
option_df=option_df[["تاریخ" , "نماد","اعمال","سررسید","تعداد","حجم","ارزش","آخرین معامله - مقدار","نام"]]
option_df.to_excel('Options_data.xlsx', index=False)
print("option dataframe has been saved.")

stock_df = df_combined[df_combined.iloc[:, 1].isin(['خودرو', 'شستا' , 'اهرم' , 'خساپا'])]
stock_df = stock_df [["تاریخ" , "نماد","تعداد","حجم","ارزش","آخرین معامله - مقدار","نام"]]
stock_df.to_excel('UAssets_data.xlsx', index=False)
print("UAssets data has been saved.")