# DataAnalytics-Assessment

This repository contains solutions to the SQL assessment tasks aimed at analyzing customer behaviors, financial activities, and operational efficiency from four tables: `users_customuser`, `savings_savingsaccount`, `plans_plan`, and `withdrawals_withdrawal`.

Each SQL file addresses one specific business question. The queries are written in standard MySQL and well-commented.

---

##  Question 1: High-Value Customers with Multiple Products

### **Task**
Identify customers who have **both a savings and an investment plan**, sorted by total deposits.

### **Approach**
- Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan` using `owner_id`.
- Filtered regular savings (`is_regular_savings = 1`) and investment plans (`is_a_fund = 1`).
- Counted both savings and investment plans per customer.
- Sum total confirmed deposits (`confirmed_amount`) for each customer.
- Converted amount from **kobo to Naira**.
- Returned users with at least 1 of each product type, sorted by deposit value.

### **Challenges**
- Ensured no double-counting of deposits for multiple savings accounts.
- Filtering out null/empty users or transactions.
- Working with raw Kobo units and converting to Naira format.

---

##  Question 2: Transaction Frequency Analysis

### **Task**
Analyze how often customers transact monthly and categorize them into:
- High Frequency (≥10/month)
- Medium Frequency (3–9/month)
- Low Frequency (≤2/month)

### **Approach**
- Used `savings_savingsaccount` to count transactions per customer.
- Calculated active months using `DATEDIFF()` between earliest and latest transaction dates.
- Computed average transactions per month.
- Used `CASE` to assign frequency categories.
- Grouped by category and counted number of customers.

### **Challenges**
- Careful handling of customers with few or spread-out transactions.
- Date calculations for active periods without errors from null dates.

---

##  Question 3: Account Inactivity Alert

### **Task**
Find all **active savings or investment accounts** with no inflow transaction in the last **365 days**.

### **Approach**
- Obtained the max transaction date per account.
- Compared against `CURDATE()` (Current Date) using `DATEDIFF()`.
- Filtered accounts with `inactivity_days > 365`.
- Included account type (Savings or Investment) using flags `is_regular_savings` and `is_a_fund`.

### **Challenges**
- Missing transaction dates on some plans required careful null handling.
- Needed to return accounts, not users – so grouped at `plan_id` level.
- Differentiating plan types accurately while combining from two tables.

---

##  Question 4: Customer Lifetime Value (CLV) Estimation

### **Task**
Estimate CLV based on:
- Account tenure (months)
- Total transactions
- Profit per transaction = 0.1% of transaction value
- CLV = `(total_tx / tenure) * 12 * avg_profit_per_tx`

### **Approach**
- Calculated tenure using `DATEDIFF()` from `date_joined` to today.
- Counted number of deposits from `savings_savingsaccount`.
- Calculated total transaction value in Naira and compute average profit.
- Estimated CLV and ordered descending.

### **Challenges**
- Some customers had zero tenure (division by zero). Resolved by replacing with 1 month minimum.
- Ensured all amounts were correctly converted from Kobo.
- Used careful joins to preserve customer identity.

---

## ✅ Folder Structure

