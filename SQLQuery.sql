--Question1: Which brand saw the most dollars spent in the month of June? -->OK
WITH cte AS
(
    SELECT
        b.BARCODE,
        b.NAME,
        ri.TOTAL_FINAL_PRICE,
        r.PURCHASE_DATE,
        MONTH(r.PURCHASE_DATE) AS month
    FROM dbo.brands_2 AS b
    JOIN dbo.receipt_items_2 AS ri
    ON b.BARCODE = ri.BARCODE
    JOIN dbo.receipts_2 AS r
    ON r.ID = ri.REWARDS_RECEIPT_ID
)

SELECT
    TOP 1 NAME,
    SUM(TOTAL_FINAL_PRICE) AS PRICE,
    MONTH
FROM cte
GROUP BY NAME, MONTH
HAVING MONTH = 6
ORDER BY price DESC;

--Question2: Which user spent the most money in the month of August? -->OK

WITH cte AS
(
    SELECT
        u.ID AS user_id,
        MONTH(r.PURCHASE_DATE) AS month,
        r.TOTAL_SPENT
    FROM users_2 AS u
    JOIN receipts_2 AS r
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

--Question3: What user bought the most expensive item?
-- CAST(ROUND(ri.TOTAL_FINAL_PRICE/ri.QUANTITY_PURCHASED, 2) AS DECIMAL(10,2)) AS item_price
WITH cte AS
(
    SELECT
        TOP 20 u.ID AS user_id,
        r.ID AS receipt_id,
        ri.DESCRIPTION AS item_name,
        ri.QUANTITY_PURCHASED,
        ri.TOTAL_FINAL_PRICE
    FROM users_2 AS u
    JOIN receipts_2 AS r
    ON u.ID = r.USER_ID
    JOIN receipt_items_2 AS ri
    ON r.ID = ri.REWARDS_RECEIPT_ID
    ORDER BY TOTAL_FINAL_PRICE DESC
)

SELECT
    TOP 1 user_id,
    item_name,
    QUANTITY_PURCHASED,
    TOTAL_FINAL_PRICE,
    TOTAL_FINAL_PRICE/QUANTITY_PURCHASED AS item_price
FROM cte
ORDER BY item_price DESC;

--Question4: What is the name of the most expensive item purchased?
-- SELECT
--     TOP 5 DESCRIPTION AS item_name,
--     QUANTITY_PURCHASED,
--     TOTAL_FINAL_PRICE,
--     ROUND(TOTAL_FINAL_PRICE/QUANTITY_PURCHASED, 2) AS item_price
-- FROM receipt_items_2
-- ORDER BY item_price DESC;

--Question5: How many users scanned in each month? >>OK
WITH cte AS
(
    SELECT
        u.ID AS user_id,
        MONTH(r.DATE_SCANNED) AS month_scanned
    FROM users_2 AS u
    JOIN receipts_2 AS r
    ON u.ID = r.USER_ID
)

SELECT
    COUNT(user_id) AS user_id_count
FROM cte
GROUP BY month_scanned;

--Question6: What is the top 10 category that has the most brand?
SELECT
    TOP 10 COUNT(NAME) AS count,
    CATEGORY AS category
FROM brands_2
GROUP BY category
HAVING category IS NOT NULL
ORDER BY count DESC;

--Question7: How much does each store earn in 2022?
SELECT
    ROUND(SUM(TOTAL_SPENT), 3) AS revenue,
    STORE_NAME AS store_name
FROM receipts_2
WHERE YEAR(PURCHASE_DATE) = 2022
GROUP BY store_name
ORDER BY revenue DESC;

--Question8: Calculate the number of user from each state.
SELECT
    COUNT(*) AS count,
    STATE AS state
FROM users_2
GROUP BY state
ORDER BY state;