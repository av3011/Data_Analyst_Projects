# 🍽️ Yelp Business Sentimental Analysis using Snowflake, AWS S3 & Python

## 📌 Problem Statement
Yelp business review data was stored in a large semi-structured JSON dataset (~5GB), making it difficult to efficiently process and analyze the data.

Challenges included:
- Handling large JSON files
- Uploading and managing semi-structured data in the cloud
- Loading JSON data into Snowflake
- Performing analysis on business reviews and categories

The goal was to build a data pipeline using Python, AWS S3, and Snowflake to process Yelp review data and perform analysis.

---

# 🎯 Objective
To process and analyze Yelp business and review data using Python, AWS S3, and Snowflake, enabling:

- Processing of large JSON datasets
- Cloud-based data storage
- Loading JSON data into Snowflake
- Business category analysis
- Review trend analysis
- User review analysis

---

# 🛠️ Tools & Technologies Used
- **Python** – File processing and AWS automation
- **boto3** – Uploading files to AWS S3
- **AWS S3** – Cloud storage
- **Snowflake** – Data warehousing and querying
- **SQL** – Data transformation and analysis
- **JSON** – Raw semi-structured data format

---

# 🗃️ Project Structure

```bash
yelp_business_sentimental_analysis/
│
├── sample_data/
│   ├── sample_businesss.json
│   └── sample_reviews.json
│
├── sql/
│   ├── analysis.sql
│   ├── create_raw_tables.sql
│   ├── storage_integration.sql
│   └── transformations.sql
│
├── src/
│   ├── config.py
│   ├── config_template.py
│   ├── logger_config.py
│   ├── main.py
│   └── upload_to_s3.py
│
└── README.md
```

> ⚠️ Original dataset size was approximately **5GB**.  
> Only sample JSON files are included in this repository.

---

# ⚙️ Data Pipeline Workflow

## 1️⃣ JSON File Processing
- Processed a ~5GB Yelp JSON dataset
- Split one large JSON file into 10 smaller files using Python

---

## 2️⃣ Upload to AWS S3
- Uploaded split JSON files to AWS S3 using Python (`boto3`)

---

## 3️⃣ Load Data into Snowflake
- Created Snowflake storage integration with AWS S3
- Loaded JSON data from S3 into Snowflake

---

## 4️⃣ Data Transformation & Analysis
Performed data transformation and analysis using SQL:
- Parsed business categories
- Structured review and business data
- Applied joins, aggregations, CTEs, and window functions

---

# 📊 Analytical Solutions Delivered

## Business Category Analysis
- Find number of businesses in each category
- Find the most popular business categories based on reviews

---

## User Review Analysis
- Find top users reviewing restaurant businesses
- Find users who wrote the most reviews

---

## Business Review Analysis
- Find top reviewed businesses
- Find top reviewed businesses in each city
- Find percentage of 5-star reviews for each business
- Find average rating for businesses with at least 100 reviews

---

## Review Trend Analysis
- Find the most recent reviews for each business
- Find month with highest number of reviews

---

# 💡 SQL Concepts Used
- CTEs
- Window Functions (`ROW_NUMBER`, `DENSE_RANK`)
- Aggregations
- Joins
- `SPLIT_TO_TABLE`
- Ranking Functions
- Filtering and Grouping

---

# 🚀 Analysis Performed

1. Find number of businesses in each category  
2. Find the top 10 users who reviewed the most restaurant businesses  
3. Find the most popular business categories based on reviews  
4. Find the top 3 most recent reviews for each business  
5. Find the month with the highest number of reviews  
6. Find percentage of 5-star reviews for each business  
7. Find the top 5 most reviewed businesses in each city  
8. Find average rating for businesses with at least 100 reviews  
9. Find top 10 users who wrote the most reviews along with businesses reviewed  
10. Find top 10 businesses with highest review counts