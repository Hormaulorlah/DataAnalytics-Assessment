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

