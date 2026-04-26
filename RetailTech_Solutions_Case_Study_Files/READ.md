# 🛒 E-commerce Sales Optimization & Customer Analytics

## 📌 Project Overview

This end-to-end data analytics project simulates a real-world business intelligence workflow for an e-commerce company. The goal is to analyze transactional data and derive actionable insights to improve **revenue**, **profitability**, **customer retention**, and **operational efficiency**.

The project covers everything from **raw data exploration and SQL cleaning** to **Python-based exploratory data analysis (EDA)** and an **interactive Power BI dashboard**.

---

## 🎯 Business Objectives

- Increase revenue and profitability
- Improve customer retention
- Optimize discounting strategies
- Enhance operational efficiency (delivery, payments)

---

## 🗂️ Dataset Structure

The project uses a **relational dataset** simulating a data warehouse:

- `customers`
- `orders`
- `order_items`
- `products`
- `payments`
- `regions`

These tables are interconnected to reflect real-world complexities like missing data, duplicates, and inconsistent categories.

---

## 🛠️ Tools & Technologies

| Stage               | Tools / Techniques                                                                 |
|---------------------|------------------------------------------------------------------------------------|
| Data Cleaning       | SQL (Window Functions, CTEs, CASE WHEN, Filtering)                                |
| Analysis (SQL)      | Aggregations, Ranking, Time-series, Multi-table Joins                             |
| EDA & Preprocessing | Python (Pandas, NumPy, Matplotlib, Seaborn)                                       |
| Visualization       | Power BI (DAX, Interactive Dashboards, Slicers)                                   |                                                                         |

---

## 📊 Key Analyses Performed

### 1. SQL Data Cleaning & Preparation

- Removed duplicates using `ROW_NUMBER()`
- Standardized categorical values (gender, order status, payment methods)
- Handled missing values and logical inconsistencies
- Created **cleaned views** for each table to ensure reusable logic

### 2. Customer Analysis

- Top 10 customers by revenue
- Average order value (AOV)
- Repeat vs one-time buyer segmentation
- Regional customer distribution

### 3. Sales & Revenue Analysis

- Monthly revenue trends and seasonality
- Regional revenue performance
- Revenue by payment method

### 4. Product & Profitability

- Top & bottom products by revenue/profit
- Profit margin by category
- Discount impact on profitability

### 5. Discount Impact Analysis

- Segmented discounts into Low (<10%), Medium (10–30%), High (>30%)
- Found that **higher discounts reduce profitability**

### 6. Operational Analysis

- Average delivery time & delayed deliveries
- Order cancellation rates
- Payment failure rates by method

### 7. Python EDA

- Feature engineering (Revenue, Order Month, Discount Levels)
- Univariate & bivariate analysis
- Correlation analysis
- Time-series trends

### 8. Power BI Dashboard

- Pages: Executive Overview, Customer Analysis, Product Profitability, Operations & Payments
- DAX measures: Total Revenue, Profit Margin, AOV, Cancellation Rate, etc.
- Slicers: Date, Category, Region, Gender
- Cross-filtering and clean UI

---

## 📈 Key Business Insights

- A **small segment of customers** contributes most of the revenue → opportunity for loyalty programs
- **Revenue shows clear seasonality** → plan promotions and inventory accordingly
- **High discounts do not guarantee profitability** → need strategic pricing
- **Home & Kitchen** is the top-performing category
- **South region** performs best among known regions
- **Payment failures and delivery delays** impact customer experience

---

## 🚀 Final Deliverables

- ✅ Cleaned SQL views and analytical queries  
- ✅ Python EDA notebook with preprocessing and visualizations  
- ✅ Interactive Power BI dashboard  
- ✅ Business-ready insights and recommendations  

---

## 📁 Repository Structure
