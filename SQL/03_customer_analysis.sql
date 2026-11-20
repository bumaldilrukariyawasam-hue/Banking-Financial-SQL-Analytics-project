-- Banking & Financial Analytics | Customer analysis
-- SYNTHETIC DATA ONLY. Balance thresholds are illustrative project categories.

-- 1. Inspect a small sample of customer records.
SELECT *
FROM banking.customers
LIMIT 10;

-- 2. Total number of customers.
SELECT COUNT(*) AS total_customers
FROM banking.customers;

-- 3. Count customers with at least one loan and customers with no loans.
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE EXISTS (
            SELECT 1
            FROM banking.loans l
            WHERE l.customer_id = c.customer_id
        )
    ) AS customers_with_loans,
    COUNT(*) FILTER (
        WHERE NOT EXISTS (
            SELECT 1
            FROM banking.loans l
            WHERE l.customer_id = c.customer_id
        )
    ) AS customers_without_loans
FROM banking.customers c;

-- 4. List a sample of customers without any loan record.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    l.loan_id
FROM banking.customers c
LEFT JOIN banking.loans l
    ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL
ORDER BY c.customer_id
LIMIT 20;

-- 5. Customer-level active account balance and illustrative segmentation.
-- Closed and Dormant accounts are excluded from active_balance.
WITH customer_balances AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(a.account_id) AS active_accounts,
        COALESCE(SUM(a.current_balance), 0) AS active_balance
    FROM banking.customers c
    LEFT JOIN banking.accounts a
        ON c.customer_id = a.customer_id
       AND a.account_status = 'Active'
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    customer_id,
    first_name,
    last_name,
    active_accounts,
    active_balance,
    CASE
        WHEN active_accounts = 0 THEN 'No Active Account'
        WHEN active_balance >= 500000 THEN 'High Balance'
        WHEN active_balance >= 100000 THEN 'Medium Balance'
        ELSE 'Low Balance'
    END AS customer_segment
FROM customer_balances
ORDER BY active_balance DESC
LIMIT 20;

-- 6. Summarise all customer balance segments.
WITH customer_balances AS (
    SELECT
        c.customer_id,
        COUNT(a.account_id) AS active_accounts,
        COALESCE(SUM(a.current_balance), 0) AS active_balance
    FROM banking.customers c
    LEFT JOIN banking.accounts a
        ON c.customer_id = a.customer_id
       AND a.account_status = 'Active'
    GROUP BY c.customer_id
),
customer_segments AS (
    SELECT
        customer_id,
        active_accounts,
        active_balance,
        CASE
            WHEN active_accounts = 0 THEN 'No Active Account'
            WHEN active_balance >= 500000 THEN 'High Balance'
            WHEN active_balance >= 100000 THEN 'Medium Balance'
            ELSE 'Low Balance'
        END AS customer_segment
    FROM customer_balances
)
SELECT
    customer_segment,
    COUNT(*) AS total_customers,
    SUM(active_accounts) AS total_active_accounts,
    SUM(active_balance) AS total_active_balance,
    ROUND(AVG(active_balance), 2) AS average_customer_balance
FROM customer_segments
GROUP BY customer_segment
ORDER BY total_active_balance DESC;
