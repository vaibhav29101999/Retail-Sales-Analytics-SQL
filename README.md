# 🛒 Retail Sales Analytics | SQL + Power BI

This project focuses on analyzing retail sales data using **SQL** and visualizing insights using **Power BI**. It covers sales performance, profit trends, salesperson targets, regional analysis, and more—providing key business intelligence to support data-driven decision-making.

---

## 📌 Objectives

- Analyze and summarize **sales, cost, and profit trends**
- Identify **top-performing products, regions, and salespeople**
- Compare **targets vs actual sales**
- Detect patterns in **customer demand and seasonality**
- Visualize key metrics through **interactive Power BI dashboards**

---

## 🧠 Key Insights

- 🏆 **Retail** emerged as the highest-performing industry  
- ⚠️ **28% deal attrition** rate observed requiring strategy review  
- 📉 **Revenue dips** predicted in January & April 2024 for planning  
- 💰 Proposed **incentives** for top agents to improve performance

---

## 📂 Folder Structure


---

## 🧮 Datasets & Schema

The analysis uses a structured relational database with the following tables:

- `sales` — Order-level data with quantity, cost, unit price
- `product` — Product-level info with categories and cost
- `region` — Regional hierarchy: region, country, group
- `reseller` — Reseller details like city, state, type
- `salesperson` — Employee data with titles and IDs
- `salespersonregion` — Salesperson-to-region mapping
- `targets` — Monthly targets per employee

---

## 🔍 SQL Analysis Areas (45+ Queries)

- Total revenue and profit across all time
- Month-on-month and year-over-year sales trends
- Top 10 products, resellers, and regions
- Target vs actual sales performance
- Profit margins and product profitability
- Missing targets, bulk orders, product seasonality
- Data validation and anomalies

📄 [View All SQL Queries](./queries/sales_analytics_queries.sql)

---

## 📊 Power BI Dashboard

Built using Power BI Desktop:
- 📅 **Monthly trends**
- 🌍 **Region-wise performance**
- 👤 **Salesperson leaderboard**
- 🎯 **Target vs Actual**
- 🛒 **Top Products by Sales & Profit**

📁 [Download Dashboard (.pbix)](./powerbi-dashboard/Retail_Sales_Dashboard.pbix)

---

## 🚀 Tools Used

- **SQL** (MySQL / PostgreSQL) — for data extraction and analysis  
- **Power BI Desktop** — for dashboarding and interactive visuals  
- **GitHub** — version control and portfolio hosting  
- **Excel / CSVs** — for initial data review (optional)

---

## 🧾 How to Run

1. Clone the repository  
2. Load the SQL schema and data into MySQL/PostgreSQL  
3. Run SQL queries from `/queries/`  
4. Open Power BI file to view dashboard (requires Power BI Desktop)

---

## 🤝 Author

**Vaibhav Kadu**  
👨‍💻 [GitHub](https://github.com/vaibhav29101999)  
📩 [LinkedIn](https://www.linkedin.com/in/your-profile/)  
📬 Email: vaibhavkadu050@gmail.com

---

## 📌 License

MIT License – Feel free to use and reference with attribution.
