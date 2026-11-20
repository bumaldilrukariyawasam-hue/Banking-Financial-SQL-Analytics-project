# pgAdmin CSV Import – Quick Guide

This guide is for loading the four synthetic CSV files into the PostgreSQL `banking` schema.

## 1. Create the schema and tables

1. Create or select the PostgreSQL database you want to use.
2. Open **Query Tool** for that database.
3. Run `SQL/01_database_setup.sql`.

This creates the `banking` schema and its four related tables. If your database is already populated, do not recreate or re-import the tables.

## 2. Import each CSV

For each table, in pgAdmin's Object Explorer expand **Schemas → banking → Tables**, right-click the target table, and choose **Import/Export Data**. Set **Import/Export** to **Import**, browse to the matching file in `Dataset/`, and use these settings:

| Option | Value |
|---|---|
| Format | csv |
| Header | ON / checked |
| Delimiter | comma ( `,` ) |
| Quote | double quote ( `"` ) |
| Escape | double quote ( `"` ) |
| Encoding | UTF8 |

Import in this order to satisfy foreign-key dependencies:

| Destination table | CSV file | Expected rows |
|---|---|---:|
| `banking.customers` | `Dataset/customers.csv` | 800 |
| `banking.accounts` | `Dataset/accounts.csv` | 1,024 |
| `banking.loans` | `Dataset/loans.csv` | 430 |
| `banking.transactions` | `Dataset/transactions.csv` | 15,000 |

**Important:** keep **Header** enabled. If it is off, PostgreSQL attempts to insert the header row as data. Blank `loan_id` cells in non-repayment transactions should become SQL `NULL`; do not replace them with zero.

## 3. Validate the imported data

Run `SQL/02_data_quality_checks.sql` and compare the row counts with the expected totals above. The validation script also checks foreign-key references, transaction-to-loan linkage, account statuses and currencies.
