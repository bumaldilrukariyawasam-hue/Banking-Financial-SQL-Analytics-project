-- Banking & Financial Analytics | Data quality and validation
-- SYNTHETIC DATA ONLY. Run after importing all four CSV files.
-- Expected row counts: customers 800, accounts 1,024, loans 430, transactions 15,000.

SET search_path TO banking, public;

-- 1. Confirm that the four expected tables exist.
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'
  AND table_schema = 'banking'
ORDER BY table_name;

-- 2. Check imported row counts.
SELECT 'customers' AS table_name, COUNT(*) AS records FROM banking.customers
UNION ALL
SELECT 'accounts', COUNT(*) FROM banking.accounts
UNION ALL
SELECT 'loans', COUNT(*) FROM banking.loans
UNION ALL
SELECT 'transactions', COUNT(*) FROM banking.transactions;

-- 3. Check missing values in required customer fields.
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_ids,
    COUNT(*) FILTER (WHERE first_name IS NULL) AS missing_first_names,
    COUNT(*) FILTER (WHERE last_name IS NULL) AS missing_last_names,
    COUNT(*) FILTER (WHERE email IS NULL) AS missing_emails
FROM banking.customers;

-- 4. Confirm account currencies and statuses.
SELECT currency, account_status, COUNT(*) AS total_accounts
FROM banking.accounts
GROUP BY currency, account_status
ORDER BY currency, account_status;

-- 5. Confirm transaction types and loan_id population.
-- Loan Repayment rows should have loan_id; other transaction types should not.
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    COUNT(loan_id) AS linked_loan_ids,
    COUNT(*) - COUNT(loan_id) AS null_loan_ids
FROM banking.transactions
GROUP BY transaction_type
ORDER BY total_transactions DESC;

-- 6. Check for orphaned references. Each result should be zero.
SELECT COUNT(*) AS orphan_accounts
FROM banking.accounts a
LEFT JOIN banking.customers c ON c.customer_id = a.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS orphan_loans_to_customers
FROM banking.loans l
LEFT JOIN banking.customers c ON c.customer_id = l.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS orphan_loans_to_accounts
FROM banking.loans l
LEFT JOIN banking.accounts a ON a.account_id = l.account_id
WHERE a.account_id IS NULL;

SELECT COUNT(*) AS orphan_transactions_to_accounts
FROM banking.transactions t
LEFT JOIN banking.accounts a ON a.account_id = t.account_id
WHERE a.account_id IS NULL;

SELECT COUNT(*) AS orphan_transactions_to_loans
FROM banking.transactions t
LEFT JOIN banking.loans l ON l.loan_id = t.loan_id
WHERE t.loan_id IS NOT NULL AND l.loan_id IS NULL;

-- 7. Check the transaction-to-loan business rule.
SELECT
    COUNT(*) FILTER (
        WHERE transaction_type = 'Loan Repayment' AND loan_id IS NULL
    ) AS repayments_missing_loan_id,
    COUNT(*) FILTER (
        WHERE transaction_type <> 'Loan Repayment' AND loan_id IS NOT NULL
    ) AS non_repayments_with_loan_id
FROM banking.transactions;

-- 8. Inspect the accounts table definition.
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'banking'
  AND table_name = 'accounts'
ORDER BY ordinal_position;
