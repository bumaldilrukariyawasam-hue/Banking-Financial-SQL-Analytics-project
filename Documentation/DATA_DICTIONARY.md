# Data Dictionary

> All records are synthetic and fictional. All monetary amounts use LKR in this training scenario.

## Entity relationship overview

| Parent | Child | Relationship | Join key |
|---|---|---|---|
| customers | accounts | One customer can own many accounts | `customer_id` |
| customers | loans | One customer can have many loans | `customer_id` |
| accounts | loans | One account can service many loans | `account_id` |
| accounts | transactions | One account can have many transactions | `account_id` |
| loans | transactions | A loan may be linked to many repayment transactions | `loan_id` (nullable in transactions) |

## customers.csv / banking.customers (800 rows)

| Column | Type | Key / rule | Description |
|---|---|---|---|
| customer_id | VARCHAR(6) | PK | Synthetic customer identifier, e.g. C00001 |
| first_name | VARCHAR(40) | NOT NULL | Fictional first name |
| last_name | VARCHAR(40) | NOT NULL | Fictional surname |
| date_of_birth | DATE | NOT NULL | Synthetic date of birth |
| gender | VARCHAR(30) | CHECK | Female, Male or Prefer not to say |
| city | VARCHAR(40) | NOT NULL | Sri Lankan city label used in the fictional sample |
| customer_segment | VARCHAR(30) | CHECK | Mass Market, Affluent or SME |
| occupation | VARCHAR(40) | NOT NULL | Synthetic occupation category |
| onboarding_date | DATE | NOT NULL | Date customer was added to the fictional bank |
| risk_band | VARCHAR(10) | CHECK | Low, Medium or High; generated label for exercises |
| email | VARCHAR(120) | UNIQUE | Fabricated .example.test address; not contactable |

## accounts.csv / banking.accounts (1,024 rows)

| Column | Type | Key / rule | Description |
|---|---|---|---|
| account_id | VARCHAR(7) | PK | Synthetic account identifier, e.g. A000001 |
| customer_id | VARCHAR(6) | FK → customers | Owner of the account |
| account_type | VARCHAR(20) | CHECK | Savings, Current or Fixed Deposit |
| open_date | DATE | NOT NULL | Account opening date |
| account_status | VARCHAR(10) | CHECK | Active, Dormant or Closed |
| current_balance | NUMERIC(16,2) | >= 0 | Synthetic current balance snapshot |
| currency | CHAR(3) | CHECK = LKR | Currency code for this training dataset |
| branch_code | VARCHAR(5) | NOT NULL | Synthetic branch identifier, e.g. BR001 |

## loans.csv / banking.loans (430 rows)

| Column | Type | Key / rule | Description |
|---|---|---|---|
| loan_id | VARCHAR(6) | PK | Synthetic loan identifier, e.g. L00001 |
| customer_id | VARCHAR(6) | FK → customers | Borrower |
| account_id | VARCHAR(7) | FK → accounts | Linked servicing account |
| loan_type | VARCHAR(20) | CHECK | Personal, Housing, Vehicle, Education or Business |
| application_date | DATE | NOT NULL | Application date |
| disbursement_date | DATE | Nullable | Blank for Pending loans |
| principal_amount | NUMERIC(16,2) | > 0 | Original synthetic principal |
| outstanding_amount | NUMERIC(16,2) | >= 0 | Synthetic outstanding balance snapshot |
| annual_interest_rate | NUMERIC(5,2) | >= 0 | Annual interest rate in percent |
| term_months | INTEGER | > 0 | Contract term in months |
| monthly_installment | NUMERIC(14,2) | >= 0 | Synthetic scheduled instalment |
| loan_status | VARCHAR(12) | CHECK | Current, Closed, Overdue, Defaulted or Pending |
| days_past_due | INTEGER | >= 0 | Synthetic DPD value |
| collateral_flag | BOOLEAN | NOT NULL | Whether the synthetic loan is marked as collateral-backed |

## transactions.csv / banking.transactions (15,000 rows)

| Column | Type | Key / rule | Description |
|---|---|---|---|
| transaction_id | VARCHAR(9) | PK | Synthetic transaction identifier, e.g. TX0000001 |
| account_id | VARCHAR(7) | FK → accounts | Account involved |
| loan_id | VARCHAR(6) | Nullable FK → loans | Populated for Loan Repayment transactions only |
| transaction_timestamp | TIMESTAMP | NOT NULL | Synthetic event timestamp |
| transaction_type | VARCHAR(20) | CHECK | Deposit, Cash Withdrawal, Transfer Out, Transfer In, Card Payment or Loan Repayment |
| channel | VARCHAR(25) | CHECK | Mobile App, Internet Banking, ATM, Branch or POS |
| amount | NUMERIC(16,2) | > 0 | Positive transaction magnitude; type determines direction/context |
| currency | CHAR(3) | CHECK = LKR | Currency code |
| transaction_status | VARCHAR(12) | CHECK | Completed, Pending or Failed |
| merchant_category | VARCHAR(30) | Nullable | Category for Card Payment rows; blank for other types |
| description | VARCHAR(80) | NOT NULL | Generic synthetic transaction description |

## Data interpretation notes

1. `amount` is always stored as a positive magnitude. Do not interpret a sum across all transaction types as net cash flow, bank income or revenue. Use `transaction_type` and define the intended metric.
2. `current_balance` is a snapshot value, not a historical balance time series.
3. Loan status and DPD are synthetic training attributes. The 90+ DPD exercise is a demonstration proxy and must not be represented as an actual regulatory NPL classification.
4. Empty `loan_id` in a non-loan transaction is expected and should remain NULL.
5. Synthetic names and email addresses must not be treated as real personal data.
