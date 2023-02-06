# Fetch_DA_2023_intern

## About The Project
This project is for Fetch Rewards Data Analytics 2023 Summer Internship. 
The following csv files are the 4 given original sample data files:

1. [brands.csv](brands.csv)

2. [receipt_items.csv](receipt_items.csv)

3. [receipts.csv](receipts.csv)

4. [users.csv](users.csv)

The goal of this project is to:
1. Review CSV data and diagram a new structured relational data model

2. Generate a query that answers a predetermined business question(s) 

3. Choose something noteworthy to share with a non-technical stakeholder

## Clean the data
First, I started cleaning the data using Python(NumPy, Pandas). I dropped useless columns, converted datatype, and saved them into new files.
For more details about how I clean the data, please see the attached Jupyter Notebook.

[Clean Data.ipynb](Clean%20Data.ipynb)

When saving new files, I add a suffix ```_2``` to differenciate them from original files. However, I changed the file name into the original one when importing csv files into SQL Server so that it is more convenient when running queries.

1. [brands_2.csv](brands_2.csv)

2. [receipt_items_2.csv](receipt_items_2.csv)

3. [receipts_2.csv](receipts_2.csv)

4. [users_2.csv](users_2.csv)


## Create a New Relational Data Model
The next step is diagraming a new structured relational data model. After cleaning the data, I created a new ER diagram(Entity-Relationship Diagram) for this database(shown as below).

**PK** stands for **Primary Key**

**FK** stands for **Foreign Key**

![Relational Data Model Diagram](Relational%20Data%20Model.png)

```
[Clean Data.ipynb](Clean Data.ipynb)
```