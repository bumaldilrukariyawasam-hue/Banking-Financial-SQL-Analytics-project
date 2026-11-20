-- Banking & Financial Analytics | Loan portfolio analysis
-- SYNTHETIC DATA ONLY. Loan categories are illustrative, not official credit-risk grades.

-- 1. Inspect a sample of loans.
SELECT *
FROM banking.loans
LIMIT 10;

-- 2. Classify loans by principal amount.
SELECT
    loan_id,
    customer_id,
    principal_amount,
    CASE
        WHEN principal_amount >= 5000000 THEN 'High-value Loan'
        WHEN principal_amount >= 2000000 THEN 'Medium-value Loan'
        ELSE 'Standard-value Loan'
    END AS loan_category
FROM banking.loans
ORDER BY principal_amount DESC
LIMIT 20;

-- 3. Summarise loan counts and principal by illustrative loan category.
SELECT
    CASE
        WHEN principal_amount >= 5000000 THEN 'High-value Loan'
        WHEN principal_amount >= 2000000 THEN 'Medium-value Loan'
        ELSE 'Standard-value Loan'
    END AS loan_category,
    COUNT(*) AS total_loans,
    SUM(principal_amount) AS total_principal,
    ROUND(AVG(principal_amount), 2) AS average_loan
FROM banking.loans
GROUP BY loan_category
ORDER BY total_principal DESC;

-- 4. Outstanding balances and average interest rate by loan status.
SELECT
    loan_status,
    COUNT(*) AS total_loans,
    SUM(principal_amount) AS total_principal,
    SUM(outstanding_amount) AS total_outstanding,
    ROUND(AVG(annual_interest_rate), 2) AS average_interest_rate
FROM banking.loans
GROUP BY loan_status
ORDER BY total_outstanding DESC;

-- 5. Loan-count share and outstanding-balance share by status.
WITH status_summary AS (
    SELECT
        loan_status,
        COUNT(*) AS total_loans,
        SUM(principal_amount) AS total_principal,
        SUM(outstanding_amount) AS total_outstanding
    FROM banking.loans
    GROUP BY loan_status
)
SELECT
    loan_status,
    total_loans,
    ROUND(100.0 * total_loans / SUM(total_loans) OVER (), 2) AS loan_percentage,
    total_principal,
    total_outstanding,
    ROUND(
        100.0 * total_outstanding
        / NULLIF(SUM(total_outstanding) OVER (), 0),
        2
    ) AS outstanding_percentage
FROM status_summary
ORDER BY total_outstanding DESC;

-- 6. Combined overdue/defaulted exposure indicator.
-- This is a descriptive synthetic-data indicator, not a regulatory NPL ratio.
SELECT
    COUNT(*) AS total_loans,
    COUNT(*) FILTER (
        WHERE loan_status IN ('Overdue', 'Defaulted')
    ) AS overdue_defaulted_loans,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE loan_status IN ('Overdue', 'Defaulted')
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS overdue_defaulted_loan_percentage,
    SUM(outstanding_amount) FILTER (
        WHERE loan_status IN ('Overdue', 'Defaulted')
    ) AS overdue_defaulted_outstanding,
    ROUND(
        100.0 * SUM(outstanding_amount) FILTER (
            WHERE loan_status IN ('Overdue', 'Defaulted')
        ) / NULLIF(SUM(outstanding_amount), 0),
        2
    ) AS overdue_defaulted_outstanding_percentage
FROM banking.loans;
