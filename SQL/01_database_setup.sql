-- Banking & Financial Analytics | SYNTHETIC TRAINING DATA ONLY
-- Run this in the PostgreSQL database you created, using pgAdmin Query Tool.
CREATE SCHEMA IF NOT EXISTS banking;
SET search_path TO banking, public;

CREATE TABLE IF NOT EXISTS customers (
    customer_id       VARCHAR(6) PRIMARY KEY,
    first_name        VARCHAR(40) NOT NULL,
    last_name         VARCHAR(40) NOT NULL,
    date_of_birth     DATE NOT NULL,
    gender            VARCHAR(30) NOT NULL CHECK (gender IN ('Female','Male','Prefer not to say')),
    city              VARCHAR(40) NOT NULL,
    customer_segment  VARCHAR(30) NOT NULL CHECK (customer_segment IN ('Mass Market','Affluent','SME')),
    occupation        VARCHAR(40) NOT NULL,
    onboarding_date   DATE NOT NULL,
    risk_band         VARCHAR(10) NOT NULL CHECK (risk_band IN ('Low','Medium','High')),
    email             VARCHAR(120) NOT NULL UNIQUE,
    CHECK (date_of_birth < onboarding_date)
);

CREATE TABLE IF NOT EXISTS accounts (
    account_id       VARCHAR(7) PRIMARY KEY,
    customer_id      VARCHAR(6) NOT NULL REFERENCES customers(customer_id),
    account_type     VARCHAR(20) NOT NULL CHECK (account_type IN ('Savings','Current','Fixed Deposit')),
    open_date        DATE NOT NULL,
    account_status   VARCHAR(10) NOT NULL CHECK (account_status IN ('Active','Dormant','Closed')),
    current_balance  NUMERIC(16,2) NOT NULL CHECK (current_balance >= 0),
    currency         CHAR(3) NOT NULL CHECK (currency = 'LKR'),
    branch_code      VARCHAR(5) NOT NULL
);

CREATE TABLE IF NOT EXISTS loans (
    loan_id              VARCHAR(6) PRIMARY KEY,
    customer_id          VARCHAR(6) NOT NULL REFERENCES customers(customer_id),
    account_id           VARCHAR(7) NOT NULL REFERENCES accounts(account_id),
    loan_type            VARCHAR(20) NOT NULL CHECK (loan_type IN ('Personal','Housing','Vehicle','Education','Business')),
    application_date     DATE NOT NULL,
    disbursement_date    DATE,
    principal_amount     NUMERIC(16,2) NOT NULL CHECK (principal_amount > 0),
    outstanding_amount   NUMERIC(16,2) NOT NULL CHECK (outstanding_amount >= 0),
    annual_interest_rate NUMERIC(5,2) NOT NULL CHECK (annual_interest_rate >= 0),
    term_months          INTEGER NOT NULL CHECK (term_months > 0),
    monthly_installment  NUMERIC(14,2) NOT NULL CHECK (monthly_installment >= 0),
    loan_status          VARCHAR(12) NOT NULL CHECK (loan_status IN ('Current','Closed','Overdue','Defaulted','Pending')),
    days_past_due        INTEGER NOT NULL CHECK (days_past_due >= 0),
    collateral_flag      BOOLEAN NOT NULL,
    CHECK (disbursement_date IS NULL OR disbursement_date >= application_date),
    CHECK (loan_status <> 'Pending' OR disbursement_date IS NULL)
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id       VARCHAR(9) PRIMARY KEY,
    account_id           VARCHAR(7) NOT NULL REFERENCES accounts(account_id),
    loan_id              VARCHAR(6) REFERENCES loans(loan_id),
    transaction_timestamp TIMESTAMP NOT NULL,
    transaction_type     VARCHAR(20) NOT NULL CHECK (transaction_type IN ('Deposit','Cash Withdrawal','Transfer Out','Transfer In','Card Payment','Loan Repayment')),
    channel              VARCHAR(25) NOT NULL CHECK (channel IN ('Mobile App','Internet Banking','ATM','Branch','POS')),
    amount               NUMERIC(16,2) NOT NULL CHECK (amount > 0),
    currency             CHAR(3) NOT NULL CHECK (currency = 'LKR'),
    transaction_status   VARCHAR(12) NOT NULL CHECK (transaction_status IN ('Completed','Pending','Failed')),
    merchant_category    VARCHAR(30),
    description          VARCHAR(80) NOT NULL,
    CHECK ((transaction_type = 'Loan Repayment' AND loan_id IS NOT NULL) OR (transaction_type <> 'Loan Repayment' AND loan_id IS NULL))
);

-- Useful indexes for common joins and time filters.
CREATE INDEX IF NOT EXISTS idx_accounts_customer ON accounts(customer_id);
CREATE INDEX IF NOT EXISTS idx_loans_customer ON loans(customer_id);
CREATE INDEX IF NOT EXISTS idx_loans_status ON loans(loan_status);
CREATE INDEX IF NOT EXISTS idx_transactions_account ON transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_transactions_loan ON transactions(loan_id);
CREATE INDEX IF NOT EXISTS idx_transactions_timestamp ON transactions(transaction_timestamp);
CREATE INDEX IF NOT EXISTS idx_transactions_status ON transactions(transaction_status);
