# 🎓 EdTech Lead Funnel Analysis

This project presents an in-depth analysis of customer acquisition and lead conversion for an EdTech platform. The goal was to identify funnel drop-offs, evaluate manager performance, and recommend strategies to improve enrollment conversions.

## 📌 Problem Statement

Analyze the lead funnel and user acquisition journey.  
Identify critical drop-off points and underperformance areas.  
Deliver insights to boost overall enrollment conversion rates.

---

## 🧾 Dataset Overview

The analysis was based on five main tables:

- **lead_details**: Lead demographics, education background, city, and source
- **demo_watch**: Demo language preferences and watch percentages
- **lead_interaction**: Interaction stages with success/failure flags
- **lead_dropoff_info**: Drop-off stages and corresponding reasons
- **assigned_managers**: Mapping of leads to junior and senior managers

---

## 🛠 Tools & Technologies

- **Python (Pandas, Jupyter Notebook)** – Data cleaning and exploratory analysis  
- **SQL (MySQL)** – Structured querying and data transformation  
- **PowerPoint** – Insight presentation and storytelling

---

## 📁 EdTech_Lead_Analysis

EdTech_Lead_Analysis
├── edtech.sql/
├── edtech.ipynb/
├── edTech_Lead_Analysis_Report.pptx
├── README.md

---

## 🧹 Data Cleaning Steps

- Checked for missing values using `isnull().sum()`
- Created derived columns for drop-off stage and reason
- Removed redundant columns after transformation for clarity
- Rename some of the values to avoid confusion
-Check for duplicates values
- Remove outliers with IQR method

---

## 🔍 Key Insights

### Demo Watch Behavior
- **Most watched language:** English > Telugu > Hindi  
- **Average demo watch percentage:** ~50%

### Lead Profile
- **Gender:** Higher proportion of female leads  
- **Location:** Mostly from South India (e.g., Bengaluru, Chennai)  
- **Education:** Majority are B.Tech students or job seekers  
- **Lead Source:** Predominantly from social media platforms

### Drop-off Analysis
- **Highest drop-off point:** Demo stage  
- **Top reasons:** Cost concerns, preference for offline programs

### Funnel Conversion
- **Overall conversion rate:** ~19.5%  
- **Conversion funnel:** Lead → Awareness → Consideration → Conversion

### Manager Performance
- Junior managers' performance varies widely  
- Senior managers average ~19.5% success rate

### Gender Impact
- **Female leads have higher conversion rates** than male leads

---

## ✅ Recommendations

- Enhance demo content engagement and localization  
- Offer flexible pricing/scholarships for online formats  
- Adjust class timing to fit student availability  
- Provide training and support for underperforming managers  
- Focus social media campaigns on South Indian female learners  
- Add mid-funnel nudges and reminders to improve progression

---

## 💥 Impact & Business Value

- **Identified 37% of total drop-offs occurring at the demo stage**, enabling targeted improvements in demo delivery.
- **Optimizing manager assignments** could boost conversion by up to **5–8%**, based on performance variation across teams.
- **Female-focused marketing** and South Indian regional targeting may unlock a **15–20% higher engagement rate**.
- Recommendations estimated to potentially **increase overall conversion rate from 19.5% to 24–26%**, improving ROI on ad spend and lead acquisition.

---

## 📎 Credits

Prepared by **Asif Vahora** 


---


