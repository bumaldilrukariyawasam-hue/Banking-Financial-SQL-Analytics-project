-- Banking & Financial Analytics | Transaction analysis
-- SYNTHETIC DATA ONLY. Transaction amount is a positive magnitude; use transaction_type
-- to understand the transaction context. Do not sum every transaction type as revenue.

-- 1. Inspect a sample of transactions.
SELECT *
FROM banking.transactions
LIMIT 10;

-- 2. Transaction volume and loan_id linkage by transaction type.
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    COUNT(loan_id) AS linked_loan_ids,
    COUNT(*) - COUNT(loan_id) AS null_loan_ids
FROM banking.transactions
GROUP BY transaction_type
ORDER BY total_transactions DESC;

-- 3. Monthly loan repayment trend.
SELECT
    DATE_TRUNC('month', transaction_timestamp)::DATE AS repayment_month,
    COUNT(*) AS repayment_transactions,
    SUM(amount) AS total_repaid,
    ROUND(AVG(amount), 2) AS average_repayment
FROM banking.transactions
WHERE transaction_type = 'Loan Repayment'
GROUP BY DATE_TRUNC('month', transaction_timestamp)
ORDER BY repayment_month;

-- 4. Five months with the highest total loan repayments.
SELECT
    DATE_TRUNC('month', transaction_timestamp)::DATE AS repayment_month,
    COUNT(*) AS repayment_count,
    SUM(amount) AS total_repaid
FROM banking.transactions
WHERE transaction_type = 'Loan Repayment'
GROUP BY DATE_TRUNC('month', transaction_timestamp)
ORDER BY total_repaid DESC
LIMIT 5;
