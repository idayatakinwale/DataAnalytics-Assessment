-- Step 1 & 2: Calculate total transactions, active months, and average per customer
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM (
    SELECT
        CASE
            WHEN total_transactions / active_months >= 10 THEN 'High Frequency'
            WHEN total_transactions / active_months >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        ROUND(total_transactions / active_months, 2) AS avg_txn_per_month
    FROM (
        SELECT
            s.owner_id,
            COUNT(*) AS total_transactions,
            TIMESTAMPDIFF(MONTH, MIN(s.created_on), MAX(s.created_on)) + 1 AS active_months
        FROM
            savings_savingsaccount s
        WHERE
            s.confirmed_amount > 0  -- Only count confirmed (funded) transactions
        GROUP BY
            s.owner_id
    ) AS transactions_per_customer
) AS categorized_customers
GROUP BY
    frequency_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
