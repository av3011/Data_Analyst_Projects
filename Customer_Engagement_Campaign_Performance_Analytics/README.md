# Customer Engagement & Campaign Performance Analytics

## 📌 Problem Statement

The marketing team at a global retail company struggles to analyze data from its multi-channel marketing campaigns. The main challenges include:
- Fragmented customer journey data across various touchpoints
- Difficulty identifying the most engaging campaigns or customer segments
- Limited insights into regional product preferences
- Manual and inefficient reporting processes

## 🎯 Objective

To clean, analyze, and visualize customer engagement and campaign performance data using SQL and Power BI to help the marketing team:
- Identify high-performing campaigns
- Understand customer behavior and product preferences
- Improve campaign targeting and customer retention

## 🛠️ Tools & Technologies Used

- **SQL Server** – Data cleaning, transformation, and metric calculation
- **Excel** – Initial data exploration

## 🗃️ Database Schema

Key tables:
- `Products`
- `Customers` & `Countries`
- `Customer_Journey`
- `Cust_Review`
- `Engag_Data`

## 🧹 Data Cleaning Highlights

- Converted `VARCHAR` date fields to `DATE` using `TRY_CONVERT()` and `CONVERT()`
- Cleaned non-numeric durations and fixed invalid `view_s_clicks_comb` values
- Split combined columns into meaningful attributes (`clicks`, `views`)
- Verified deduplication; no duplicate records in key tables

## 📊 Key Metrics & Analysis

- **Click-Through Rate (CTR)**: Highest in Campaign 16 (21.38%)
- **Conversion Rate**: Highest in Campaign 18 (5.11%)
- **Interaction Rate**: Surfboard (25.97%), Running Shoes (25.74%)
- **Drop-Off Analysis**: Checkout stage had the most drop-offs (590 users)
- **Content Performance**: Social Media, Blogs, and Video content performed best
- **Demographic Insight**: Spain had the highest product purchases, especially winter gear

## 💡 Business Insights & Recommendations

- Focus budget on high-performing campaigns (IDs: 15, 19, 3)
- Simplify the checkout process to reduce drop-offs
- Promote high-engagement products (Surfboard, Running Shoes)
- Prioritize content types like Social Media and Blogs
- Target regions like Spain and Italy with regional-specific products
- Launch loyalty programs based on Customer Lifetime Value (CLV)



### 📁 Customer Engagement & Campaign Performance Analytics
```
Customer_Engagement_Campaign_Performance_Analytics/
│
├── Customer_Engagement_Campaign_Performance_Analytics.sql # SQL cleaning and analysis scripts
├── Customer_Engagement_Campaign_Performance_Analytics.pptx # Final presentation/report (PPT)
├── products.csv
├── customers.csv
├── countries.csv
├── customer_journey.csv
├── cust_review.csv
├── engag_data.csv
├── README.md
```
## 📎 Credits

Prepared by **Asif Vahora** 

