-- Step 1: Get last inflow date for each Savings account
SELECT
    s.plan_id,
    s.owner_id,
    'Savings' AS type,
    MAX(s.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.created_on)) AS inactivity_days
FROM
    savings_savingsaccount s
WHERE
    s.confirmed_amount > 0
GROUP BY
    s.plan_id,
    s.owner_id

UNION

-- Step 2: Get last inflow date for each Investment account
SELECT
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    MAX(s.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.created_on)) AS inactivity_days
FROM
    plans_plan p
JOIN
    savings_savingsaccount s ON p.id = s.plan_id
WHERE
    s.confirmed_amount > 0
    AND p.is_a_fund = 1  -- Only investment plans
GROUP BY
    p.id,
    p.owner_id
HAVING
    inactivity_days > 365;
