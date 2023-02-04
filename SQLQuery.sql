--Question1: Which brand saw the most dollars spent in the month of June?
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
    SUM(TOTAL_FINAL_PRICE) AS price,
    MONTH
FROM cte
GROUP BY NAME, MONTH
HAVING MONTH = 6
ORDER BY price DESC;

--Question2: