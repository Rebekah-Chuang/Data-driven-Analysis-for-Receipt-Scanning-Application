--Question1: Which brand saw the most dollars spent in the month of June?
--brand name : Brooks(139.99 USD)

WITH cte AS
(
    SELECT
        b.BARCODE,
        b.NAME AS brand_name,
        ri.TOTAL_FINAL_PRICE,
        r.PURCHASE_DATE,
        MONTH(r.PURCHASE_DATE) AS month
    FROM dbo.brands AS b
    JOIN dbo.receipt_items AS ri
    ON b.BARCODE = ri.BARCODE
    JOIN dbo.receipts AS r
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

--Question2: Which user spent the most money in the month of August?
--user_id:609ab37f7a2e8f2f95ae968f
--spent 157844.68 USD in August

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

--Question3: What user bought the most expensive item?
-- user_id:617376b8a9619d488190e0b6

--Question4: What is the name of the most expensive item purchased?
--item_name : Starbucks Iced Coffee Premium Coffee Beverage Unsweetened Blonde Roast Bottle 48 Oz 1 Ct

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
    user_id,
    item_name,
    item_price
FROM cte
ORDER BY item_price DESC;

--Question5: How many users scanned in each month?

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
    COUNT(user_id) AS user_id_count
FROM cte
GROUP BY month_scanned;

--Question6: What is the top 10 category that has the most brands?

SELECT
    TOP 10 COUNT(NAME) AS brand_count,
    CATEGORY AS category
FROM brands
GROUP BY category
HAVING category IS NOT NULL
ORDER BY brand_count DESC;

--Question7: How much does each store earn in 2022?

SELECT
    ROUND(SUM(TOTAL_SPENT), 3) AS revenue,
    STORE_NAME AS store_name
FROM receipts
WHERE YEAR(PURCHASE_DATE) = 2022
GROUP BY store_name
ORDER BY revenue DESC;

--Question8: Calculate the number of user from each state.

SELECT
    COUNT(*) AS count,
    STATE AS state
FROM users
GROUP BY state
ORDER BY state;

--Question9: What is the age distribution of the registered users?