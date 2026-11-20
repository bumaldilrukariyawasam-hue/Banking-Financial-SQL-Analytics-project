# Start Here – SQL-only project

This repository contains only the PostgreSQL / SQL portfolio work. It intentionally excludes Power BI files and dashboard materials.

## If your database is already populated

1. Open pgAdmin Query Tool for your existing database.
2. Run `SQL/02_data_quality_checks.sql` first.
3. Review the SQL files in order from `03_customer_analysis.sql` through `06_advanced_sql.sql`.

Do not re-run the import process if your four tables already contain the 17,254 records.

## If you are setting up from scratch

1. Create a PostgreSQL database. The database name can be your choice.
2. Run `SQL/01_database_setup.sql`. This creates the `banking` schema and four tables.
3. Import CSV files from `Dataset/` in this order: customers, accounts, loans, transactions.
4. In the pgAdmin import dialog, enable **Header**, choose CSV, comma delimiter and UTF-8 encoding.
5. Follow `Documentation/PGADMIN_IMPORT_GUIDE.md`.
6. Run `SQL/02_data_quality_checks.sql`.
7. Run the customer, transaction, loan and advanced SQL analyses.

## SQL file order

- `01_database_setup.sql` – schema, tables, keys, constraints and indexes.
- `02_data_quality_checks.sql` – counts, null checks, status checks and referential integrity.
- `03_customer_analysis.sql` – loan participation and active-balance segmentation.
- `04_transaction_analysis.sql` – transaction types and monthly repayments.
- `05_loan_portfolio_analysis.sql` – loan categories, status shares and overdue/defaulted exposure.
- `06_advanced_sql.sql` – joins, CTEs, ranking and window functions.
