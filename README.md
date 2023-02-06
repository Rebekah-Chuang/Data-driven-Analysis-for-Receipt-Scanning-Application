# Fetch_DA_2023_intern

## About The Project
This project is for Fetch Rewards Data Analytics 2023 Summer Internship. 
The following csv files are the 4 given original sample data files:

1. [brands.csv](Original%20csv%20files/brands.csv)

2. [receipt_items.csv](Original%20csv%20files/receipt_items.csv)

3. [receipts.csv](Original%20csv%20files/receipts.csv)

4. [users.csv](Original%20csv%20files/users.csv)

The goal of this project is to:
1. Review CSV data and diagram a new structured relational data model

2. Generate a query that answers a predetermined business question(s) 

3. Choose something noteworthy to share with a non-technical stakeholder

## Clean the data
First, I started cleaning the data using Python(NumPy, Pandas). I dropped useless columns, converted datatype, and saved them into new files.
For more details about how I clean the data, please see the attached Jupyter Notebook.

[Clean Data.ipynb](Clean%20Data.ipynb)

When saving new files, I add a suffix ```_2``` to differenciate them from original files. However, I changed the file name into the original one when importing csv files into SQL Server so that it is more convenient when running queries.

1. [brands_2.csv](New%20csv%20files/brands_2.csv)

2. [receipt_items_2.csv](New%20csv%20files/receipt_items_2.csv)

3. [receipts_2.csv](New%20csv%20files/receipts_2.csv)

4. [users_2.csv](New%20csv%20files/users_2.csv)


## Create a New Relational Data Model
The next step is diagraming a new structured relational data model. After cleaning the data, I created a new ER diagram(Entity-Relationship Diagram) for this database(shown as below).

**PK** stands for **Primary Key**

**FK** stands for **Foreign Key**

![Relational Data Model Diagram](Relational%20Data%20Model.png)

 ## SQL Queries
After creating a new relational data model, I need to write queries to ansert questions from business stakeholders.
The SQL dialect I chose was **MSSQL**

Question 1-5 are those given by Fetch Rewards, and Question 6-10 are those I created that might be helpful.
For the original files of SQL Queries, please see attached file, but I will also leave my code and notes below!
 
 [SQL Queries](SQLQuery.sql)

 **Question1: Which brand saw the most dollars spent in the month of June?**
 
 ```
WITH cte AS
(
    SELECT
        b.BARCODE,
        b.NAME AS brand_name,
        ri.TOTAL_FINAL_PRICE,
        r.PURCHASE_DATE,
        MONTH(r.PURCHASE_DATE) AS month
    FROM brands AS b
    JOIN receipt_items AS ri
    ON b.BARCODE = ri.BARCODE
    JOIN receipts AS r
    ON r.ID = ri.REWARDS_RECEIPT_ID
)

SELECT
    TOP 1 brand_name,
    SUM(TOTAL_FINAL_PRICE) AS price,
    month
FROM cte
GROUP BY brand_name, month
HAVING MONTH = 6
ORDER BY price DESC;
 ```
![Q1 output](SQL%20questions%20output/Q1%20output.png)

**Question2: Which user spent the most money in the month of August?**
```
WITH cte AS
(
    SELECT
        u.ID AS user_id,
        MONTH(r.PURCHASE_DATE) AS month,
        r.TOTAL_SPENT
    FROM users AS u
    JOIN receipts AS r
    ON u.ID = r.USER_ID
)

SELECT
    TOP 1 user_id,
    month,
    SUM(TOTAL_SPENT) AS total_spent
FROM cte
GROUP BY user_id, month
HAVING month = 8
ORDER BY total_spent DESC;
```
![Q2 output](SQL%20questions%20output/Q2%20output.png)