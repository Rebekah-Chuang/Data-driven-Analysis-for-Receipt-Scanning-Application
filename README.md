# Fetch_DA_2023_intern

## Table of Contents

* [Introduction](https://github.com/Rebekah-Chuang/Fetch_DA_2023_intern#introduction)
* [About The Project](https://github.com/Rebekah-Chuang/Fetch_DA_2023_intern#about-the-project)
* [Clean the data](https://github.com/Rebekah-Chuang/Fetch_DA_2023_intern#clean-the-data)
* [PartI: Create a New Relational Data Model](https://github.com/Rebekah-Chuang/Fetch_DA_2023_intern#create-a-new-relational-data-model)
* [PartII: SQL Queries](https://github.com/Rebekah-Chuang/Fetch_DA_2023_intern#sql-queries)
* [PartIII: Insights](https://github.com/Rebekah-Chuang/Fetch_DA_2023_intern#insights)

## Introduction
**Name:** Chi-Ying(Rebekah)Chuang

**School:** University of Illinois at Urbana-Champaign

**Degree:** Master of Science

**Program:** Information Management

**Expected Graduation:** May 2024

## About The Project
This project is for Fetch Rewards Data Analytics 2023 Summer Internship. 
The following csv files are the 4 given original sample data files:

Path:  ```Fetch_DA_2023_intern/Original csv files/ ```

1. [brands.csv](Original%20csv%20files/brands.csv)

2. [receipt_items.csv](Original%20csv%20files/receipt_items.csv)

3. [receipts.csv](Original%20csv%20files/receipts.csv)

4. [users.csv](Original%20csv%20files/users.csv)

The goal of this project is to:
1. Review CSV data and diagram a new structured relational data model

2. Generate a query that answers a predetermined business question(s) 

3. Choose something noteworthy to share with a non-technical stakeholder

## Clean the data
First, I cleaned the data using **Python(NumPy, Pandas)**. I dropped useless columns, converted datatype, and saved them into new files. For more details about how I clean the data, please see the attached Jupyter Notebook.

Path:  ```Fetch_DA_2023_intern/Clean Data.ipynb ```

[Clean Data.ipynb](Original%20csv%20files/Clean%20Data.ipynb)

When saving new files, I add a suffix ```_2``` to differentiate them from the original files. However, I changed the file name to the original one when importing csv files into SQL Server to make it more convenient when running queries.

Path:  ```Fetch_DA_2023_intern/New csv files/ ```

1. [brands_2.csv](New%20csv%20files/brands_2.csv)

2. [receipt_items_2.csv](New%20csv%20files/receipt_items_2.csv)

3. [receipts_2.csv](New%20csv%20files/receipts_2.csv)

4. [users_2.csv](New%20csv%20files/users_2.csv)


## Create a New Relational Data Model
The next step is diagraming a new structured relational data model. After cleaning the data, I created a new ER diagram(Entity-Relationship Diagram) using **Lucidchart** for this database(shown below).

**PK** stands for **Primary Key**

**FK** stands for **Foreign Key**

![Relational Data Model Diagram](Relational%20Data%20Model.png)

 ## SQL Queries
After creating a new relational data model, I need to write queries to answer questions from business stakeholders. The SQL dialect I chose was **MS SQL Server**.

Questions 1-5 are those given by Fetch Rewards, and Questions 6-10 are those I created that might be helpful. For the original files of SQL Queries, please see attached file, but I will also leave my code and notes below!

Path:  ```Fetch_DA_2023_intern/SQLQuery.sql ```
 
 [SQL Queries](SQLQuery.sql)


 ### Question1: Which brand saw the most dollars spent in the month of June?
 
 ```SQL
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


### Question2: Which user spent the most money in the month of August?
```SQL
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


### Question3: What user bought the most expensive item?
### Question4: What is the name of the most expensive item purchased?

> **Note**
>
>Questions 3&4 can be answered using the same query. After looking at the output, I believe there might be some typo in the original file because the price of **Starbucks Iced Coffee Premium Coffee Beverage Unsweetened Blonde Roast Bottle 48 Oz 1 Ct** shouldn't be that high. However, since I'm not sure about the correct price and if there are any other typos, I decided to keep the original number. 

```SQL
WITH cte AS
(
    SELECT
        u.ID AS user_id,
        r.ID AS receipt_id,
        ri.DESCRIPTION AS item_name,
        CAST(ROUND(ri.TOTAL_FINAL_PRICE, 2) AS DECIMAL(10,2)) AS total_final_price,
        ri.QUANTITY_PURCHASED AS quantity_purchased,
        CAST(ROUND(total_final_price/quantity_purchased, 2) AS FLOAT) AS item_price
    FROM users AS u
    JOIN receipts AS r
    ON u.ID = r.USER_ID
    JOIN receipt_items AS ri
    ON r.ID = ri.REWARDS_RECEIPT_ID
    WHERE (total_final_price IS NOT NULL)
    AND (total_final_price != 0)
    AND (quantity_purchased IS NOT NULL)
    AND (quantity_purchased != 0)
)
SELECT
    TOP 1 user_id,
    item_name,
    item_price
FROM cte
ORDER BY item_price DESC;
```
![Q3Q4 output](SQL%20questions%20output/Q3Q4%20output.png)


### Question5: How many users scanned in each month?

```SQL
WITH cte AS
(
    SELECT
        u.ID AS user_id,
        MONTH(r.DATE_SCANNED) AS month_scanned
    FROM users AS u
    JOIN receipts AS r
    ON u.ID = r.USER_ID
)

SELECT
    CASE WHEN month = 1 THEN 'JAN'
    WHEN month = 2 THEN 'FEB'
    WHEN month = 3 THEN 'MAR'
    WHEN month = 4 THEN 'APR'
    WHEN month = 5 THEN 'MAY'
    WHEN month = 6 THEN 'JUN'
    WHEN month = 7 THEN 'JUL'
    WHEN month = 8 THEN 'AUG'
    WHEN month = 9 THEN 'SEP'
    WHEN month = 10 THEN 'OCT'
    WHEN month = 11 THEN 'NOV'
    ELSE 'DEC' END AS month,
    user_id_count
FROM
(
    SELECT
        TOP 12 month_scanned AS month,
        COUNT(user_id) AS user_id_count
    FROM cte
    GROUP BY month_scanned
    ORDER BY month
)sub;
```

![Q5 output](SQL%20questions%20output/Q5%20output.png)


### Question6: What is the top 10 category that has the most brands?

```SQL
SELECT
    TOP 10 COUNT(NAME) AS brand_count,
    CATEGORY AS category
FROM brands
GROUP BY category
HAVING category IS NOT NULL
ORDER BY brand_count DESC;
```

![Q6 output](SQL%20questions%20output/Q6%20output.png)


### Question7: How much does each store earn in 2022 (list top 20)?

```SQL
SELECT
    TOP 20 STORE_NAME AS store_name,
    ROUND(SUM(TOTAL_SPENT), 3) AS revenue
FROM receipts
WHERE YEAR(PURCHASE_DATE) = 2022
GROUP BY store_name
ORDER BY revenue DESC;
```

![Q7 output](SQL%20questions%20output/Q7%20output.png)


### Question8: What are the top 5 states that registered users come from?

```SQL
SELECT
    TOP 5 STATE AS state,
    COUNT(*) AS count
FROM users
GROUP BY state
ORDER BY count DESC;
```

![Q8 output](SQL%20questions%20output/Q8%20output.png)


### Question9: What is the age distribution of the registered users?

```SQL
WITH cte AS
(
    SELECT
        *,
        CASE WHEN age BETWEEN 0 AND 10 THEN '0-10'
        WHEN age BETWEEN 11 AND 20 THEN '11-20'
        WHEN age BETWEEN 21 AND 30 THEN '21-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 60 THEN '51-60'
        WHEN age BETWEEN 61 AND 70 THEN '61-70'
        WHEN age BETWEEN 71 AND 80 THEN '71-80'
        END AS age_range
    FROM
    (
        SELECT
            *,
            2023 - YEAR(BIRTH_DATE) AS age
        FROM users
    ) sub
)

SELECT
    age_range,
    COUNT(*) AS age_range_count
FROM cte
GROUP BY age_range;
```

![Q9 output](SQL%20questions%20output/Q9%20output.png)


### Question10: What is the distribution of the sign up source?

```SQL
SELECT
    SIGN_UP_SOURCE AS sign_up_source,
    COUNT(*) AS source_count
FROM users
GROUP BY sign_up_source;
```

![Q10 output](SQL%20questions%20output/Q10%20output.png)


## Insights
For the last part, I used **Tableau** to create visualizations and dashboards to help non-technical stakeholders easily understand my analysis.

### 1. Distribution of Registered Users **(Map)**:

The visualization below shows the distribution of registered users. From this visualization, we know that Florida State has the most registered users since the color of Florida is the darkest on the whole map.
    
    

https://user-images.githubusercontent.com/83235098/217133145-8b174404-0184-4d1a-99e5-03d0e3bfc845.mov



### 2. Rewards Receipts Status **(Highlight table)**:

From the highlight table below, we can know the number and percentage of the receipt that is FINISHED/FLAGGED/PENDING/REJECTED/SUBMITTED. For example, among all the rewards receipts, 91.15% of them are finished(which is 64,350). The darker color represents the higher percentage/number.
    
    

https://user-images.githubusercontent.com/83235098/217133184-c99301a7-4f10-404f-a90a-969c8ee72d94.mov



### 3. Top 20 Stores's Revenue By Year(2020-2023) **(Treemap)**:

I created a treemap in the following dashboard to visualize the store's revenue(top 20) each year. Users can use the slider above the dashboard to filter the year they want. The bigger the area, the larger the revenue. Users can see the corresponding store name and revenue that year when they hover over the dashboard.
    
    

https://user-images.githubusercontent.com/83235098/217133216-0c7da09b-73c7-4774-afc9-e090d7d34180.mov



### 4. Brand Count(By Category) **(Treemap)**:

This visualization can be used to answer Question 6. From this treemap, we know that **Beverages** is the category with the most brand among all the categories. Users can see the category and brand count when they hover over the visualization.
    
    

https://user-images.githubusercontent.com/83235098/217133252-923d1f49-df9a-40c6-b57b-67944dea77fc.mov



### 5. Scanned User(By Year/Quarter) **(Bar chart)**:

The dashboard below can be used to answer Question 5 and helps stakeholders visualize the number of users scanned in a specific year or quarter. Users can use the slider to filter quarters and the dropdown to filter years.



https://user-images.githubusercontent.com/83235098/217133291-b997dce8-fdc8-44d9-85f1-6956f885fa5c.mov

