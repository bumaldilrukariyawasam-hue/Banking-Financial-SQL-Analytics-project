# Upload the remaining CSV datasets and screenshots

The SQL scripts and Markdown documentation have already been published to the `main` branch. The source CSVs and PNG screenshots remain in the companion SQL-only ZIP archive because the connected GitHub file-writing interface cannot transfer those binary/archive payloads directly.

## A. Upload the four CSV datasets

1. Download and extract `Banking-Financial-SQL-Analytics-SQL-Only.zip`.
2. Open this repository on GitHub.
3. Open the `Dataset` folder.
4. Select **Add file → Upload files**.
5. From the extracted archive, open its `Dataset` folder and select:
   - `customers.csv`
   - `accounts.csv`
   - `loans.csv`
   - `transactions.csv`
6. Wait for the files to finish uploading, enter commit message `Add synthetic banking CSV datasets`, and click **Commit changes**.

## B. Upload the query evidence screenshots

Repeat the same process in the repository's `Screenshots` folder. Select the PNG files from the extracted archive's `Screenshots` folder:

- `customer_balance_segmentation.png`
- `customers_with_and_without_loans.png`
- `loan_portfolio_by_status.png`
- `monthly_loan_repayments.png`
- `overdue_defaulted_exposure.png`
- `three_table_loan_repayment_join.png`

Commit with message `Add pgAdmin SQL analysis screenshots`.

## C. Verify the completed repository

The `Dataset` folder should contain four CSV files and `README.md`. The `Screenshots` folder should contain six PNG files and `README.md`.

> All source records are synthetic and fictional. Never upload real customer, account, loan or transaction records.
