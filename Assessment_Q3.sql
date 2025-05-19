WITH all_transactions AS (
    SELECT
        plan_id,
        owner_id,
        MAX(transaction_date) AS last_transaction_date,
        'Savings' AS type
    FROM savings_savingsaccount
    WHERE transaction_status = 'successful'
    GROUP BY plan_id, owner_id

    UNION ALL

    SELECT
        id AS plan_id,
        owner_id,
        MAX(created_on) AS last_transaction_date,
        'Investment' AS type
    FROM plans_plan
    WHERE amount > 0  -- Assuming only plans with a deposit are valid
    GROUP BY id, owner_id
),
inactive_accounts AS (
    SELECT
        plan_id,
        owner_id,
        type,
        last_transaction_date,
        DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
    FROM all_transactions
    WHERE last_transaction_date < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
)
SELECT *
FROM inactive_accounts
ORDER BY inactivity_days DESC;
