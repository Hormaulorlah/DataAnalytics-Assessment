WITH customer_transactions AS (
    SELECT
        owner_id AS customer_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) * 0.001 AS total_profit
    FROM savings_savingsaccount
    WHERE transaction_status = 'successful'
    GROUP BY owner_id
),
customer_tenure AS (
    SELECT
        id AS customer_id,
        name,
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM users_customuser
),
clv_calculation AS (
    SELECT
        t.customer_id,
        u.name,
        u.tenure_months,
        t.total_transactions,
        ROUND(
            (t.total_transactions / NULLIF(u.tenure_months, 0)) * 12 * (t.total_profit / NULLIF(t.total_transactions, 0)),
            2
        ) AS estimated_clv
    FROM customer_transactions t
    JOIN customer_tenure u ON t.customer_id = u.customer_id
)
SELECT *
FROM clv_calculation
ORDER BY estimated_clv DESC;

