# Banking & Financial Analytics — SQL Portfolio Project

**PostgreSQL portfolio project using a synthetic banking dataset.**

> All customer, account, loan, transaction and monetary records in this repository are synthetic and fictional. They are provided for educational use only and do not represent any real bank or customer.

## Project overview

A PostgreSQL and SQL portfolio project exploring customer accounts, loan portfolios, transaction activity and repayment trends. The project demonstrates relational database design, data validation, joins, aggregations, CTEs, CASE expressions and window functions.

## Dataset

| Table | Records |
|---|---:|
| customers | 800 |
| accounts | 1,024 |
| loans | 430 |
| transactions | 15,000 |
| **Total** | **17,254** |

All account and transaction values are in LKR in this synthetic training dataset.

## Repository structure

- `Dataset/` — four synthetic CSV files.
- `SQL/` — database setup, data quality checks, customer analysis, transaction analysis, loan portfolio analysis and advanced SQL.
- `Documentation/` — data dictionary, pgAdmin import guide, project findings and start guide.
- `Screenshots/` — selected pgAdmin query output evidence.

## Skills demonstrated

PostgreSQL, relational database design, primary and foreign keys, constraints and indexes, data quality checks, joins, aggregations, CASE WHEN, CTEs, RANK, DENSE_RANK, LAG, cumulative SUM window functions, monthly repayment analysis and customer/loan segmentation.

## Getting started

1. Create a PostgreSQL database (for example `banking_analytics`).
2. Run `SQL/01_database_setup.sql` in pgAdmin Query Tool.
3. Import the four CSV files into the `banking` schema in this order: customers, accounts, loans, transactions. Enable Header, use comma delimiter and UTF-8.
4. Run `SQL/02_data_quality_checks.sql` and verify the row counts.
5. Explore the analysis scripts in `SQL/03` through `SQL/06`.

See `Documentation/START_HERE.md`, `Documentation/PGADMIN_IMPORT_GUIDE.md` and `Documentation/DATA_DICTIONARY.md` for instructions.

## Selected findings

Results below are descriptive observations from the included synthetic dataset and the author's PostgreSQL analysis:

- 328 customers had at least one loan record; 472 had no loan record.
- Account statuses: 912 Active, 74 Dormant and 38 Closed.
- Illustrative active-balance segments: 589 High Balance, 126 Medium Balance, 23 Low Balance and 62 No Active Account.
- Loan statuses: 319 Current, 29 Overdue, 17 Defaulted, 5 Pending and 60 Closed.
- Total loan principal: LKR 1,586,446,366.66; total outstanding: LKR 697,415,118.48.
- Overdue and Defaulted exposure: 46 loans and LKR 94,891,792.19 outstanding (13.61% of total outstanding). This is not a regulatory NPL ratio.

## Limitations

This is synthetic educational data, not real financial institution data. Customer and loan segments use illustrative thresholds, not official bank policies. The combined overdue/defaulted exposure is a descriptive training indicator, not an official NPL ratio. Transaction amounts are positive magnitudes; interpret them by transaction type and do not treat their sum as revenue or profit.

## Author

Bumal Kariyawasam  
GitHub: https://github.com/bumaldilrukariyawasam-hue
