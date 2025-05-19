-- Step 1: Calculate total transactions and average confirmed_amount per customer
SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- Step 2: Calculate tenure in months from date_joined to today
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    
    -- Step 3: Count total savings transactions per customer
    COUNT(s.id) AS total_transactions,
    
    -- Step 4: Estimate CLV using the given simplified model
    ROUND(
        (
            COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)
        ) * 12 *
        (
            0.001 * AVG(s.confirmed_amount) / 100  -- convert to naira
        ), 2
    ) AS estimated_clv

FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id

WHERE 
    s.confirmed_amount > 0

GROUP BY 
    u.id, name, u.date_joined

ORDER BY 
    estimated_clv DESC;
