# DataAnalytics-Assessment

Question 1:  High-Value Customers with Multiple Products

**Approach:**

- Identified customers who have at least one funded savings plan and one funded investment plan.
- Defined "funded" as:
  - `confirmed_amount > 0` in the `savings_savingsaccount` table.
  - `amount > 0 AND is_a_fund = 1` in the `plans_plan` table.
- Used `COUNT(*)` to determine the number of savings and investment plans per customer.
- Calculated total deposits using `SUM(confirmed_amount)` from the savings table.
- Applied Common Table Expressions (CTEs) with the `WITH` clause to organize the logic:
  - One CTE for funded savings accounts.
  - One CTE for funded investment plans.
- Joined the CTEs on `owner_id` to identify customers who have both.
- Sorted the final result by `total_deposits` in descending order.

### ⚠️ Challenges

1. **Understanding table relationships**  
   Determining how `users_customuser`, `savings_savingsaccount`, and `plans_plan` were connected required careful inspection. It was established that `owner_id` is the linking key across these tables.

2. **Interpreting "funded"**  
   The schema did not include an explicit "funded" flag. This was addressed by using logical conditions:
   - For savings: `confirmed_amount > 0`
   - For investments: `amount
  

Question 2: Transaction Frequency Analysis

### ✅ Per-Question Explanation

**Approach:**

- The goal was to determine how frequently customers transact each month, then group them into segments:
  - High Frequency (≥10 transactions/month)
  - Medium Frequency (3–9 transactions/month)
  - Low Frequency (≤2 transactions/month)
- Used `DATE_FORMAT()` to group transactions by month and customer.
- Calculated the **average monthly transaction count** per customer using `AVG()`.
- Categorized customers using a `CASE` statement based on the thresholds.
- Aggregated results to count the number of customers per segment and calculate the average transaction frequency per segment.

### ⚠️ Challenges

1. **Time-based aggregation**  
   Monthly grouping required consistent date formatting (`'%Y-%m'`) to avoid mixing years and months.

2. **Handling inactive months**  
   Customers without activity in a given month do not appear in that month’s data. The average was calculated only over active months, which is a realistic reflection of user behavior.

3. **Ensuring accuracy**  
   To ensure valid data, filtered transactions by `transaction_status = 'successful'`.

4. **Sorting categories logically**  
   Used `FIELD()` in the final `ORDER BY` to ensure consistent sorting of frequency categories.


Question 3: Account Inactivity Alert

### ✅ Per-Question Explanation

**Approach:**

- The goal was to flag savings or investment plans that haven’t had any inflow in the last 365 days.
- Combined data from:
  - `savings_savingsaccount` – using the latest successful `transaction_date`
  - `plans_plan` – using `created_on` as a proxy for transaction date for funded plans
- Labeled each row as either **Savings** or **Investment** to differentiate the type.
- Filtered for plans where the most recent transaction was **more than 1 year ago**.
- Calculated `inactivity_days` using `DATEDIFF()`.

### ⚠️ Challenges

1. **No universal transaction date**  
   Investment plans lacked consistent transaction logs, so `created_on` was used as a best-effort fallback for last inflow.

2. **Different date fields per table**  
   Used `transaction_date` for savings vs. `created_on` for investments.

3. **Ensuring active plans only**  
   For investments, filtered with `amount > 0` to ignore empty or archived entries.

4. **Categorizing output**  
   Labeled each result clearly as "Savings" or "Investment" for clarity in reporting.

Question 4: Customer Lifetime Value (CLV) Estimation

### ✅ Per-Question Explanation

**Objective:**  
Estimate each customer’s CLV using:
- Account tenure (in months)
- Number of successful transactions
- A fixed profit margin of 0.1% per transaction

**CLV Formula Used:**  
CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

### 🔍 Steps Taken:

1. **customer_transactions CTE**  
   - Counts all successful transactions per customer.
   - Calculates total profit as `SUM(confirmed_amount * 0.001)`.

2. **customer_tenure CTE**  
   - Computes tenure in months using `TIMESTAMPDIFF()` between `date_joined` and today.

3. **clv_calculation CTE**  
   - Calculates average profit per transaction.
   - Uses the provided CLV formula, rounded to 2 decimals.
   - Handles edge cases using `NULLIF` to avoid division by zero.

4. **Final Output**  
   - Displays each customer's ID, name, tenure, transaction count, and estimated CLV.
   - Sorted by `estimated_clv` in descending order.

### ⚠️ Challenges

- Ensured zero-tenure customers do not cause division errors (`NULLIF(tenure, 0)`).
- Assumed only successful savings transactions count toward CLV.
- `confirmed_amount` used as transaction value for CLV calculation.




