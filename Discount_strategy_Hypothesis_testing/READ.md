Evaluating the Impact of Discount Strategies on Customer Spending Using Hypothesis Testing
🧭 Overview

This project analyzes the impact of discount strategies on customer purchasing behavior in an e-commerce setting. Using statistical hypothesis testing, the goal is to determine whether offering discounts leads to a significant change in Average Order Value (AOV).

The analysis is designed to simulate real-world business decision-making, helping organizations optimize pricing and promotional strategies.

🎯 Business Problem

E-commerce companies frequently use discounts to boost sales, but it is unclear whether these discounts actually increase customer spending or simply reduce profit margins.

Key Question:

Do discounts significantly increase the average order value?

📊 Dataset
Synthetic e-commerce transaction dataset (5000+ records)
Features include:
Order ID
Customer ID
Order Value
Discount Applied (Yes/No)
Discount Percentage
Product Category
Customer Type (New/Returning)
Order Date



🧪 Methodology
1. Data Preparation & EDA
Data cleaning and validation
Exploratory Data Analysis (EDA)
Group comparison (Discount vs No Discount)

3. Assumption Testing
Levene’s Test → Check equality of variances
Normality check (sampling approach)

5. Hypothesis Testing
Independent Sample t-test
H₀: No difference in AOV
H₁: Discounts impact AOV

6. Statistical Metrics
p-value
Confidence Interval (95%)
Effect size (Cohen’s d)
📈 Key Results
Mean Increase in AOV: ₹156.84
p-value: < 0.001 (statistically significant)
95% Confidence Interval: ₹115 – ₹198

🧠 Insights
Customers receiving discounts spend significantly more per order
The increase in AOV is consistent and statistically reliable
Discounts act as an effective lever for increasing transaction value

💼 Business Impact
Supports data-driven pricing decisions
Helps optimize discount and promotional strategies
Highlights trade-off between revenue growth and profit margins
Can be extended to customer segmentation and personalization

⚠️ Limitations
Synthetic dataset (may not capture all real-world complexities)
Profitability not directly analyzed
External factors (seasonality, campaigns) not included
🛠️ Tech Stack
Python
Pandas
NumPy
SciPy
Matplotlib / Seaborn
