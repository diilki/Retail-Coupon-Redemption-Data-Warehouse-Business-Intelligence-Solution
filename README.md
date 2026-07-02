# 🚀 Retail Coupon Redemption Data Warehouse

End-to-end **Data Warehouse & Business Intelligence** solution built using **SQL Server, SSIS, SSAS, and Power BI** for Retail Coupon Redemption Analytics.

![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![SSIS](https://img.shields.io/badge/SSIS-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)
![SSAS](https://img.shields.io/badge/SSAS-512BD4?style=for-the-badge&logo=microsoft&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

---

# 📖 Project Overview

This project demonstrates the design and implementation of a complete **Data Warehouse and Business Intelligence (DWBI)** solution for a **Retail Coupon Redemption** system.

The solution transforms raw operational data collected from multiple heterogeneous data sources into a centralized dimensional data warehouse capable of supporting enterprise-level analytics and business intelligence.

The project includes:

✅ ETL Development using SSIS

✅ Snowflake Schema Design

✅ Historical Data Tracking (SCD Type 2)

✅ Accumulating Fact Table

✅ SSAS OLAP Cube Development

✅ Interactive Power BI Dashboards

---

# 📊 Dataset Information

This project uses the **Predicting Coupon Redemption Feature Selection** dataset available on Kaggle.

The dataset simulates the marketing operations of a retail organization where promotional campaigns and coupons are used to increase customer engagement and sales.

The dataset was transformed into a complete enterprise data warehouse through multiple ETL stages, dimensional modeling, OLAP cube development, and business intelligence reporting.

---

## Dataset Contents

👥 Customers

🎯 Campaigns

🎟 Coupon Redemption

📦 Products

🏷 Product Brands

📂 Product Categories

🛒 Customer Transactions

📍 Customer Addresses

---

## Dataset Source

Dataset available on Kaggle

🔗 https://www.kaggle.com/datasets

---

## Source Files Used

CouponCustomerAddress.xlsx

CouponItemCategory.txt

CampaignData.csv

CouponRedemp.csv

Customer_Info.csv

Items.csv

ProductBrand.csv

Customer_ItemTransaction.csv

The data was extracted from Excel, CSV, Text files, and SQL Server before being loaded into the staging database and finally transformed into the Data Warehouse.

---

# 🏗️ Solution Architecture

<p align="center">
<img src="screenshots/solution_architecture.png" width="900">
</p>

---

## Data Flow

```
Excel Files
CSV Files
Text Files
SQL Database
      │
      ▼
Source Database
      │
      ▼
Staging Database
      │
      ▼
Data Warehouse
(Snowflake Schema)
      │
      ▼
SSAS Cube
      │
      ▼
Power BI Reports
```

---

# 🛠 Technology Stack

| Category | Technology |
|------------|------------|
| Database | SQL Server |
| ETL | SSIS |
| Data Warehouse | Snowflake Schema |
| OLAP | SSAS |
| Visualization | Power BI |
| Development | Visual Studio, SSMS |

---

# 📂 Data Sources

The project integrates multiple source formats.

📊 Excel Files (.xlsx)

📄 CSV Files (.csv)

📝 Text Files (.txt)

🗄 SQL Server Database

This simulates a real-world enterprise data engineering environment where data originates from multiple operational systems.

---

# ⭐ Data Warehouse Design

<p align="center">
<img src="screenshots/snowflake_schema.png" width="850">
</p>

The warehouse follows a **Snowflake Schema** to reduce redundancy while maintaining analytical performance.

---

## Dimension Tables

👤 DimCustomer *(SCD Type 2)*

📅 DimDate

🎯 DimCampaign

🎟 DimCouponRedemption

📦 DimItem

🏷 DimProductBrand

📂 DimCategory

---

## Fact Table

🛒 FactTransaction *(Accumulating Fact Table)*

---

# 🔄 ETL Pipeline (SSIS)

The ETL solution was developed using SQL Server Integration Services.

---

## SSIS Packages

📥 Coupon_Load_Staging

Loads source data into staging tables.

🏗 Coupon_Load_DW

Loads dimensions and fact tables into the warehouse.

🔄 Coupon_Update_FactTransaction

Updates transaction completion timestamps and processing duration.

---

# 📈 Slowly Changing Dimensions (SCD Type 2)

Historical tracking was implemented for:

👤 DimCustomer

Tracked attributes include

- StartDate
- EndDate
- IsCurrent

This preserves customer history and enables accurate historical reporting.

---

# ⚡ Accumulating Fact Table

The FactTransaction table supports transaction lifecycle analysis.

Tracked metrics include

- Transaction Create Time
- Transaction Completion Time
- Processing Duration

This enables monitoring of operational performance and transaction processing efficiency.

---

# 🧠 OLAP Cube Development (SSAS)

The OLAP Cube was developed using SQL Server Analysis Services.

---

## Cube Dimensions

👤 Customer

📦 Item

📅 Date

🎟 Coupon Redemption

---

## Measures

💰 Total Discounted Expense

📊 Transaction Metrics

---

## Supported OLAP Operations

✅ Roll-Up

✅ Drill-Down

✅ Slice

✅ Dice

✅ Pivot Analysis

---

# 📊 Power BI Dashboards

The Data Warehouse was visualized using Microsoft Power BI.

Implemented reports include

📌 Matrix Report

📌 Multiple Slicer Dashboard

📌 Drill Down Report

📌 Drill Through Report

<p align="center">
<img src="screenshots/powerbi_dashboard.png" width="900">
</p>

---

## Dashboard Features

📈 Interactive Filtering

📊 KPI Monitoring

📅 Trend Analysis

👥 Customer Analysis

🎟 Coupon Redemption Analysis

💰 Business Performance Insights

---

# 🗺 Entity Relationship Diagram

<p align="center">
<img src="screenshots/ER_Diagram.png" width="900">
</p>

---

# 📁 Repository Structure

```
Retail-Coupon-Redemption-DWBI/
│
├── datasets/
├── documentation/
├── sql/
├── ssis/
├── ssas/
├── powerbi/
├── screenshots/
├── README.md
└── .gitignore
```

---

# 📚 Documentation

Detailed project documentation can be found in:

📄 01_Data_Warehouse_Design_and_ETL_Report.pdf

📄 02_SSAS_OLAP_and_PowerBI_Report.pdf

---

# 🎯 Key Skills Demonstrated

- Data Warehousing
- Business Intelligence
- SQL Server
- ETL Development
- SSIS Package Development
- Snowflake Schema Design
- SCD Type 2
- Accumulating Fact Tables
- SSAS Cube Development
- OLAP Analysis
- Power BI Dashboard Development
- Data Modeling
- SQL

---

# 👩‍💻 Author

**Dilki Shanika**

🎓 BSc (Hons) in Information Technology – Data Science Specialization

🏛 Sri Lanka Institute of Information Technology (SLIIT)

💡 Aspiring Data Engineer | Data Analyst | Business Intelligence Enthusiast

---

⭐ If you found this project interesting, feel free to explore the repository, documentation, and dashboards. Don't forget to **Star ⭐ this repository** if you found it useful!
