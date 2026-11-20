# Project Findings (Synthetic Dataset)

These values are the results the project author observed in pgAdmin while analysing the supplied synthetic CSVs. They are descriptive outputs, not real-bank benchmarks.

## Dataset profile

| Table | Rows |
|---|---:|
| customers | 800 |
| accounts | 1,024 |
| loans | 430 |
| transactions | 15,000 |
| **Total rows across tables** | **17,254** |

All account and transaction currency values in the provided sample are LKR.

## Customer and account analysis

- Customers with at least one loan: 328.
- Customers with no loan record: 472.
- Accounts: 912 Active, 74 Dormant, 38 Closed.
- Active-account customer segmentation (illustrative thresholds):
  - High Balance: 589 customers; LKR 982,376,569.47 active balance.
  - Medium Balance: 126 customers; LKR 37,933,019.93 active balance.
  - Low Balance: 23 customers; LKR 1,083,843.71 active balance.
  - No Active Account: 62 customers; LKR 0 active balance.
- Total active account balance: LKR 1,021,393,433.11.

## Transaction analysis

- Total transactions: 15,000.
- Transaction-type counts: Card Payment 3,820; Transfer Out 3,476; Deposit 2,996; Cash Withdrawal 2,169; Transfer In 1,802; Loan Repayment 737.
- All 737 Loan Repayment transactions have a `loan_id`; non-repayment transaction types have NULL `loan_id` in this dataset by design.
- Repayment months run from January 2024 to October 2026 (34 monthly groups).
- The average monthly repayment total returned by the analysis was LKR 1,019,789.04.
- October 2026 was the largest month in the shown top-five query: 201 repayments totalling LKR 8,858,088.48.

## Loan portfolio analysis

- Loan statuses: Current 319; Closed 60; Overdue 29; Defaulted 17; Pending 5.
- Total principal amount: LKR 1,586,446,366.66.
- Total outstanding amount: LKR 697,415,118.48.
- Current loans had LKR 602,523,326.29 outstanding.
- Overdue loans had LKR 63,660,143.45 outstanding.
- Defaulted loans had LKR 31,231,648.74 outstanding.
- Combined overdue/defaulted exposure: 46 loans (10.70% of all loans), LKR 94,891,792.19 outstanding (13.61% of total outstanding).
- Principal-amount categories used in the practice query: High-value (>= LKR 5,000,000): 110 loans; Medium-value (>= LKR 2,000,000 and < LKR 5,000,000): 134 loans; Standard-value (< LKR 2,000,000): 186 loans.

## Interpretation cautions

- This is synthetic data. Findings must not be presented as the performance or risk position of a real bank.
- The High/Medium/Low balance and loan-value categories use thresholds selected for SQL practice, not an institution's official segmentation policy.
- Overdue plus Defaulted outstanding is a combined descriptive exposure indicator, not a regulatory NPL ratio.
- The current balance fields are snapshot values; no historical daily account balance series is provided.
- Transaction amounts are positive magnitudes. Use transaction type to describe their context; do not call the sum of every transaction type revenue or net cash flow.
- An unusually high value in a synthetic period is a dataset observation, not evidence of a real-world cause.
