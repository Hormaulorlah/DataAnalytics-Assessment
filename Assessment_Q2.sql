WITH monthly_transactions AS (
    SELECT
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS year_month,
        COUNT(*) AS transactions_per_month
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'successful'  -- Assuming only successful transactions count
    GROUP BY s.owner_id, year_month
),
avg_transactions AS (
    SELECT
        owner_id,
        AVG(transactions_per_month) AS avg_txn_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),
categorized_customers AS (
    SELECT
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        owner_id,
        avg_txn_per_month
    FROM avg_transactions
)
SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');


