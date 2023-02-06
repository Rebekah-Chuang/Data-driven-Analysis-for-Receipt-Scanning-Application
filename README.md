# Fetch_DA_2023_intern

## About The Project
The following csv files are the original ones:

[brands.csv](brands.csv)

[receipt_items.csv](receipt_items.csv)

[receipts.csv](receipts.csv)

[users.csv](users.csv)


## Clean the data
First, I started cleaning the data using Python. I dropped useless columns, converted datatype, and save them into new files.
For more details about how I clean the data, please see the attached Jupyter Notebook.

[Clean Data.ipynb](Clean Data.ipynb)

[brands_2.csv](https://github.com/Rebekah-Chuang/Fetch_DA_2023_intern/blob/main/brands_2.csv)

[receipt_items_2.csv](https://github.com/Rebekah-Chuang/Fetch_DA_2023_intern/blob/main/receipt_items_2.csv)

[receipts_2.csv](https://github.com/Rebekah-Chuang/Fetch_DA_2023_intern/blob/main/receipts_2.csv)

[users_2.csv](https://github.com/Rebekah-Chuang/Fetch_DA_2023_intern/blob/main/users_2.csv)



When saving new files, I add a suffix '_2' to differenciate them from original files. However, I changed the file name into the original one when importing csv files into SQL Server.

```
[Clean Data.ipynb](Clean Data.ipynb)
```
## Relational Data Model Diagram
![Relational Data Model Diagram](Relational%20Data%20Model.png)