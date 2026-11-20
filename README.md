# Banking & Financial Analytics — SQL Portfolio Project

**PostgreSQL portfolio project using a fictional banking dataset.**

> **Synthetic data notice:** All customer, account, loan, transaction, date and monetary records in the companion dataset archive are synthetic and fictional. They do not represent a real bank, real customers, or actual banking performance.

## Project overview

This project demonstrates relational database design and analytical SQL using PostgreSQL and pgAdmin 4. It explores customer and account relationships, loan portfolio composition, transaction activity, loan repayment trends and illustrative customer balance segments.

## Dataset profile

| Table | Expected rows | Primary key |
|---|---:|---|
| `banking.customers` | 800 | `customer_id` |
| `banking.accounts` | 1,024 | `account_id` |
| `banking.loans` | 430 | `loan_id` |
| `banking.transactions` | 15,000 | `transaction_id` |
| **Total** | **17,254** | |

All account and transaction values use LKR in this synthetic training dataset.

**Dataset upload note:** The four CSV source files are included in the companion SQL-only ZIP package, but have not yet been committed to this GitHub repository. Extract the package and upload `customers.csv`, `accounts.csv`, `loans.csv` and `transactions.csv` into `Dataset/` to make the repository fully reproducible. `Dataset/README.md` contains the upload reminder.

## Database relationships

- One customer may own multiple accounts and have multiple loans.
- Each account belongs to one customer.
- Each loan references a customer and a servicing account.
- Each transaction references an account. `loan_id` is nullable and is populated for Loan Repayment transactions in this dataset.

## SQL skills demonstrated

- PostgreSQL schema and table creation
- Primary keys, foreign keys, `NOT NULL`, `CHECK` constraints and indexes
- Data validation, row-count checks, NULL checks and orphan-reference checks
- Filtering and sorting with `WHERE`, `ORDER BY` and `LIMIT`
- Aggregations using `COUNT`, `SUM`, `AVG` and `GROUP BY`
- Conditional logic with `CASE WHEN`
- Relational joins: `INNER JOIN` and `LEFT JOIN`
- CTEs (`WITH`) and multiple CTEs
- Window functions: `RANK`, `DENSE_RANK`, `LAG` and cumulative `SUM() OVER()`
- Monthly repayment analysis and month-over-month percentage change

## Repository structure

```text
Dataset/          Upload the four CSV files from the companion ZIP here
SQL/              Six PostgreSQL setup, validation and analysis scripts
Documentation/    Data dictionary, pgAdmin import guide and findings
Screenshots/      Folder for selected pgAdmin query output evidence
README.md
```

## Getting started

### If your database is already populated

Open pgAdmin Query Tool for your existing database and run `SQL/02_data_quality_checks.sql`. If the expected records are present, continue with `SQL/03_customer_analysis.sql` through `SQL/06_advanced_sql.sql`. Do not re-import the CSVs into already-populated tables.

### If you are setting up from scratch

1. Install PostgreSQL and pgAdmin 4.
2. Create a PostgreSQL database (the database name is your choice).
3. Open Query Tool for that database.
4. Run `SQL/01_database_setup.sql` to create the `banking` schema and four related tables.
5. Extract the companion ZIP and upload/import the four CSV files in this order: customers, accounts, loans, transactions.
6. In pgAdmin's Import/Export dialog, select Import and CSV; enable **Header**; use comma as delimiter and UTF-8 encoding.
7. Run `SQL/02_data_quality_checks.sql` and verify the expected row counts.
8. Explore the analysis scripts from `SQL/03` through `SQL/06`.

See `Documentation/PGADMIN_IMPORT_GUIDE.md` and `Documentation/DATA_DICTIONARY.md` for details.

## Selected findings from the author's SQL outputs

The following are descriptive results observed while analysing the supplied synthetic data:

- 328 customers had at least one loan record; 472 had no loan record.
- Accounts: 912 Active, 74 Dormant and 38 Closed.
- Active-account customer segmentation, using illustrative balance thresholds: 589 High Balance, 126 Medium Balance, 23 Low Balance and 62 No Active Account customers.
- Loan statuses: 319 Current, 29 Overdue, 17 Defaulted, 5 Pending and 60 Closed.
- Total loan principal: LKR 1,586,446,366.66; total outstanding balance: LKR 697,415,118.48.
- Combined Overdue and Defaulted exposure: 46 loans, LKR 94,891,792.19 outstanding (13.61% of total outstanding). This is a descriptive sample indicator, not a regulatory NPL ratio.
- Monthly repayment analysis covered January 2024 to October 2026 (34 months); October 2026 was the highest month in the top-five query, with 201 repayments totalling LKR 8,858,088.48.

Detailed notes are in `Documentation/PROJECT_FINDINGS.md`.

## Limitations and responsible interpretation

- This is a synthetic educational dataset, not an analysis of a real financial institution.
- High/Medium/Low customer balance groups and loan principal bands use illustrative thresholds, not official bank policies.
- Overdue/defaulted exposure is a descriptive training indicator, not a regulatory non-performing-loan ratio.
- `current_balance` is a snapshot, not a historical daily balance series.
- Transaction `amount` values are positive magnitudes. Do not sum all transaction types and describe the result as revenue, profit or net cash flow. Interpret amounts in context using `transaction_type`.

## Author

**Bumal Kariyawasam**  
Statistics graduate | Aspiring Data Analyst & Data Scientist  
LinkedIn: https://www.linkedin.com/in/bumal-kariyawasam-4052b1247/  
GitHub: https://github.com/bumaldilrukariyawasam-hue
