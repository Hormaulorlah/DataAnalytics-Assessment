-- Define savings and investment data that can be reused first
WITH funded_savings AS (
    SELECT 
        owner_id,
        COUNT(*) AS savings_count,
        SUM(confirmed_amount) AS total_savings
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),
funded_investments AS (
    SELECT 
        owner_id,
        COUNT(*) AS investment_count,
        SUM(amount) AS total_investments
    FROM plans_plan
    WHERE amount > 0 AND is_a_fund = 1
    GROUP BY owner_id
)

-- Final result joining only users with both savings and investments
SELECT 
    c.id AS owner_id,
    COALESCE(c.name, CONCAT(c.first_name, ' ', c.last_name)) AS name,
    fs.savings_count,
    fi.investment_count,
    fs.total_savings + fi.total_investments AS total_deposits
FROM users_customuser c
INNER JOIN funded_savings fs ON c.id = fs.owner_id
INNER JOIN funded_investments fi ON c.id = fi.owner_id
ORDER BY total_deposits DESC;

