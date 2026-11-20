-- Banking & Financial Analytics | Advanced SQL: JOINs, CTEs and window functions
-- SYNTHETIC DATA ONLY.

-- 1. INNER JOIN across customers, loans and loan repayment transactions.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    l.loan_id,
    l.principal_amount,
    l.outstanding_amount,
    l.annual_interest_rate,
    t.transaction_timestamp,
    t.amount AS repayment_amount
FROM banking.customers c
INNER JOIN banking.loans l
    ON c.customer_id = l.customer_id
INNER JOIN banking.transactions t
    ON l.loan_id = t.loan_id
WHERE t.transaction_type = 'Loan Repayment'
ORDER BY t.transaction_timestamp DESC
LIMIT 20;

-- 2. Total repayment amount and repayment count by customer.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(t.transaction_id) AS repayment_count,
    COUNT(DISTINCT l.loan_id) AS total_loans_with_repayments,
    SUM(t.amount) AS total_repaid,
    ROUND(AVG(t.amount), 2) AS average_repayment
FROM banking.customers c
INNER JOIN banking.loans l
    ON c.customer_id = l.customer_id
INNER JOIN banking.transactions t
    ON l.loan_id = t.loan_id
WHERE t.transaction_type = 'Loan Repayment'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_repaid DESC
LIMIT 20;

-- 3. CTE: monthly loan repayment summary.
WITH monthly_repayments AS (
    SELECT
        DATE_TRUNC('month', transaction_timestamp)::DATE AS repayment_month,
        COUNT(*) AS repayment_count,
        SUM(amount) AS total_repaid
    FROM banking.transactions
    WHERE transaction_type = 'Loan Repayment'
    GROUP BY DATE_TRUNC('month', transaction_timestamp)
)
SELECT *
FROM monthly_repayments
ORDER BY total_repaid DESC;

-- 4. Multiple CTEs: months above the average monthly repayment collection.
WITH monthly_repayments AS (
    SELECT
        DATE_TRUNC('month', transaction_timestamp)::DATE AS repayment_month,
        COUNT(*) AS repayment_count,
        SUM(amount) AS total_repaid
    FROM banking.transactions
    WHERE transaction_type = 'Loan Repayment'
    GROUP BY DATE_TRUNC('month', transaction_timestamp)
),
average_monthly AS (
    SELECT AVG(total_repaid) AS avg_monthly_repayment
    FROM monthly_repayments
)
SELECT
    m.repayment_month,
    m.repayment_count,
    m.total_repaid,
    ROUND(a.avg_monthly_repayment, 2) AS average_monthly_repayment
FROM monthly_repayments m
CROSS JOIN average_monthly a
WHERE m.total_repaid > a.avg_monthly_repayment
ORDER BY m.total_repaid DESC
LIMIT 5;

-- 5. RANK and DENSE_RANK: rank loans by principal amount.
SELECT
    loan_id,
    customer_id,
    principal_amount,
    RANK() OVER (ORDER BY principal_amount DESC) AS loan_rank,
    DENSE_RANK() OVER (ORDER BY principal_amount DESC) AS dense_loan_rank
FROM banking.loans
ORDER BY principal_amount DESC
LIMIT 20;

-- 6. LAG: compare each month's repayment with the previous month.
WITH monthly_repayments AS (
    SELECT
        DATE_TRUNC('month', transaction_timestamp)::DATE AS repayment_month,
        SUM(amount) AS total_repaid
    FROM banking.transactions
    WHERE transaction_type = 'Loan Repayment'
    GROUP BY DATE_TRUNC('month', transaction_timestamp)
)
SELECT
    repayment_month,
    total_repaid,
    LAG(total_repaid) OVER (ORDER BY repayment_month) AS previous_month,
    total_repaid - LAG(total_repaid) OVER (ORDER BY repayment_month) AS repayment_difference
FROM monthly_repayments
ORDER BY repayment_month;

-- 7. Month-over-month percentage change in loan repayments.
WITH monthly_repayments AS (
    SELECT
        DATE_TRUNC('month', transaction_timestamp)::DATE AS repayment_month,
        SUM(amount) AS total_repaid
    FROM banking.transactions
    WHERE transaction_type = 'Loan Repayment'
    GROUP BY DATE_TRUNC('month', transaction_timestamp)
),
monthly_comparison AS (
    SELECT
        repayment_month,
        total_repaid,
        LAG(total_repaid) OVER (ORDER BY repayment_month) AS previous_month
    FROM monthly_repayments
)
SELECT
    repayment_month,
    total_repaid,
    previous_month,
    ROUND(
        100.0 * (total_repaid - previous_month) / NULLIF(previous_month, 0),
        2
    ) AS monthly_change_percentage
FROM monthly_comparison
ORDER BY repayment_month;

-- 8. Cumulative loan repayments (running total by month).
WITH monthly_repayments AS (
    SELECT
        DATE_TRUNC('month', transaction_timestamp)::DATE AS repayment_month,
        SUM(amount) AS total_repaid
    FROM banking.transactions
    WHERE transaction_type = 'Loan Repayment'
    GROUP BY DATE_TRUNC('month', transaction_timestamp)
)
SELECT
    repayment_month,
    total_repaid,
    SUM(total_repaid) OVER (
        ORDER BY repayment_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_repayments
FROM monthly_repayments
ORDER BY repayment_month;
