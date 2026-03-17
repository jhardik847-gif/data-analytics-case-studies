📊 Customer Shopping Behavior Analysis
🔍 Project Overview

This project focuses on analyzing customer shopping behavior using transactional data of 3,900 purchases across multiple product categories. The objective is to uncover actionable insights related to customer spending patterns, product preferences, segmentation, and subscription behavior to support data-driven business decisions.

📁 Dataset Summary

Total Records: 3,900

Total Features: 18

Key Attributes:

Customer Demographics (Age, Gender, Location, Subscription Status)

Purchase Details (Item, Category, Amount, Season, Size, Color)

Behavioral Data (Discount Usage, Purchase Frequency, Ratings, Shipping Type)

Data Quality Issue: Missing values in Review Rating column handled during preprocessing

🧹 Data Cleaning & Preprocessing (Python)

Loaded dataset using Pandas

Performed initial exploration using .info() and .describe()

Handled missing values using median imputation (category-wise)

Standardized column names to snake_case

Created new features:

age_group

purchase_frequency_days

Removed redundant columns (e.g., promo_code_used)

Integrated cleaned dataset into PostgreSQL for further analysis

🛢️ Data Analysis (SQL)

Performed business-driven analysis using SQL:

Revenue comparison by gender

Identification of high-spending discount users

Top 5 products by average rating

Shipping type impact on purchase behavior

Subscriber vs non-subscriber revenue analysis

Discount-dependent products

Customer segmentation (New, Returning, Loyal)

Top products by category

Repeat buyers vs subscription behavior

Revenue contribution by age group

📈 Key Insights

Male customers contributed significantly higher revenue than female customers (as seen in SQL output on page 3)

Express shipping users showed slightly higher average purchase value (page 4)

Non-subscribers generated more total revenue, but subscribers showed similar average spending (page 4)

Majority of customers fall under the Loyal segment (page 5)

Certain products (e.g., hats, sneakers) are highly dependent on discounts (page 5)

📊 Dashboard (Power BI)

An interactive dashboard was built in Power BI to visualize:

Customer distribution

Revenue by category

Sales by age group

Subscription insights

Average purchase metrics

(Refer to dashboard snapshot on page 7)

💡 Business Recommendations

Increase subscription adoption through exclusive benefits

Implement loyalty programs for repeat customers

Optimize discount strategies to balance profitability

Promote top-rated and best-selling products

Target high-revenue age groups with personalized marketing

🛠️ Tech Stack

Python (Pandas, NumPy) – Data Cleaning & Feature Engineering

SQL (PostgreSQL) – Data Analysis

Power BI – Data Visualization & Dashboarding

🚀 Conclusion

This project demonstrates an end-to-end data analysis workflow — from data cleaning and transformation to SQL-based analysis and dashboard creation — delivering actionable insights that can enhance customer targeting, product strategy, and revenue growth.
