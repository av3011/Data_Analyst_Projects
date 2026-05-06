# Multi-Store Sales Performance Analysis

## 📌 Problem Statement

A retail toy chain with 50 stores across 29 cities was struggling with:
- Poor visibility into store and product performance
- Ineffective inventory turnover tracking
- Fragmented data limiting marketing and stock decisions

The goal was to generate actionable insights to improve revenue, optimize inventory, and boost campaign ROI.

## 🎯 Objective

To clean and analyze multi-store sales, product, and store data using SQL and Power BI, enabling:
- Store-level performance comparisons
- Product profitability insights
- Time-based sales tracking
- Smarter inventory and replenishment planning

## 🛠️ Tools & Technologies Used

- **SQL Server** – Data cleaning, transformation, aggregation, ranking
- **Power BI** – Interactive dashboards, drill-down analysis, KPIs
- **CSV Files** – Raw data sources

## 🗃️ Multi-Store Sales Performance Analysis
```
Multi_Store_Sales_Analysis/
│
├── Multi_Store_Analysis.sql # SQL scripts for data cleaning & analysis
├── Multi_Store_Analysis.pbix # Power BI dashboard
├── Multi_Store_Report.pptx # Business presentation/report
├── products.csv 
├── sales.csv 
├── stores.csv 
├── README.md
```

## 🧹 Data Cleaning & Transformation

- Removed `$` symbols from cost/price and converted to `DECIMAL`
- Joined datasets using `JOIN` and `LEFT JOIN`
- Filled nulls and ensured all key tables were normalized
- Aggregated data by **month**, **quarter**, and **year**
- Applied `RANK()` and `PARTITION BY` to compare store/product performance

## 📊 Analytical Solutions Delivered

- **KPIs**: Total sales, product count, store count, cities covered
- **Sales Trends**: Monthly, quarterly, and yearly
- **Top & Bottom Stores**: Ranked by revenue and units sold
- **Product Insights**: Bestsellers and most profitable items
- **Location Insights**: High-revenue cities like Ciudad de Mexico
- **Inventory Turnover**: Improved stock efficiency using custom metrics

## 💡 Key Insights

- **Top Products**: Lego Bricks and Colorbuds
- **Most Profitable**: Colorbuds (2022–2023)
- **Top Locations**: Ciudad de Mexico and high-performing cities
- **Inventory Fixes**: Reduced overstock and understock through turnover tracking

## 📈 Power BI Dashboard Features

- KPI Cards (total sales, stores, products, cities)
- Line graphs, bar charts, pie charts, and maps
- Interactive filters for store, city, product, and time
- Drill-down enabled for detailed business storytelling

## 🚀 Business Impact

- 💡 Identified opportunities to improve marketing ROI through targeted sales analysis
- 📈 Highlighted high-performing products and stores to support revenue growth strategies
- 📦 Reduced carrying costs through inventory optimization
- ⏱️ Enabled real-time decision-making via Power BI

## 📎 Credits

Prepared by **Asif Vahora** 
