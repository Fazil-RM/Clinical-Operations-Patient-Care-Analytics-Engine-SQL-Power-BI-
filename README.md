# Clinical Operations & Patient Care Analytics Engine (SQL + Power BI)

## 🏥 Executive Project Summary
This project delivers a comprehensive operational and clinical performance audit of a healthcare dataset tracking **9,000+ patient visits**. 

The solution leverages an exhaustive data engineering pipeline built in **SQL** to clean, profile, and structure raw operational records. These insights are then translated into an interactive, 3-page **Power BI Dashboard** that maps patient demographics, analyzes departmental throughput bottlenecks, and correlates physical wait times with patient satisfaction scores. The final analytics suite empowers hospital administration to make data-driven decisions to optimize care delivery and reduce operational strain.

---

## 🛠️ Tech Stack & Architecture
* **Data Engineering & EDA:** SQL (MySQL Server) - *50 structured production queries*
* **Business Intelligence & Visualization:** Power BI Desktop
* **Key Metrics Tracked:** Patient Satisfaction Index (1-10), Wait Time Metrics, Department Throughput, Admission Conversion Rates, and Population Demographics.

---

## 📂 Repository Deliverables
* 📁 **`healthcare_analysis.sql`**: The production SQL script containing 50 structured queries divided into data cleansing, demographic profiling, and advanced operational diagnostic tracking.
* 📁 **`healthcare_analysis_dashboard.pbix`**: The master Power BI dashboard file utilizing clean layout structures, explicit measures, and interactive data navigation features.
* 📁 **`healthcare_dataset.csv`**: The primary data source supporting the relational schema.

---

## 🗃️ Analytical Pipeline Breakdown

### Part 1: SQL Data Engineering & Cleansing
Before visualization, the raw transaction schema was stress-tested across a 50-query script to establish absolute data integrity:
1. **Sanity & Duplicate Audits:** Inspected structural integrity, identified zero structural duplicate patient keys, and evaluated null distributions across critical metrics.
2. **Data Standardization:** Cleaned categorical strings using `TRIM()` functions and handled uneven spacing within patient name indices.
3. **Operational Transformation:** Grouped continuous ages into structured categorical lifecycle buckets (*Children, Youth, Adults, Seniors*) using multi-conditional `CASE WHEN` logic.
4. **Statistical Diagnostics:** Engineered subqueries inside `HAVING` structures to extract high-risk operational performance anomalies—isolating clinics where average wait times exceeded organizational benchmarks while satisfaction scores fell below median targets.

---

## 📈 Power BI Interactive Dashboard Performance

## 📈 Power BI Interactive Dashboard Breakdowns

### Page 1 | Executive Clinical Operations Overview
* **Objective:** Provide senior hospital leadership with immediate, high-level visibility into active system capacity, patient volume trends, and baseline service delivery metrics.
* **Key Visuals:** High-visibility KPI cards displaying total patient cohorts (9,948 records) alongside key admission metrics. Features a clean dual-axis chart tracking peak volume hours (AM vs. PM load shifts) and specialized department referral volumes to optimize operational staffing workflows.

![Page 1 - Executive Clinical Operations Overview](https://ik.imagekit.io/fazil/page-1-ss.png)

---

### Page 2 | Patient Demographics & Diversity Profiling
* **Objective:** Map and evaluate the socio-demographic characteristics of the incoming patient population to improve clinical equity and guide targeted community health resource allocation.
* **Key Visuals:** Cross-functional demographic breakdowns splitting patient cohorts across age bands (*Children, Youth, Adults, Seniors*), gender proportions, and diverse racial segment indices. Includes structural distribution charts identifying high-volume user demographics requiring specialized care infrastructure.

![Page 2 - Patient Demographics & Diversity Profiling](https://ik.imagekit.io/fazil/page-2-ss.png)

---

### Page 3 | Clinical Throughput & Care Satisfaction Analytics
* **Objective:** Diagnose severe operational bottlenecks by directly cross-referencing patient wait times against clinical quality performance scores.
* **Key Visuals:** A high-density pivot matrix cross-analyzing multidimensional patient profiles against exact physical wait times (minutes) and care satisfaction tiers (1-10 scale). Accompanied by trend distribution metrics isolating the clear operational inflection points where front-end delays trigger structural drops in patient satisfaction.

![Page 3 - Clinical Throughput & Care Satisfaction Analytics](https://ik.imagekit.io/fazil/page-3-ss.png)
---

## 🎯 Strategic Operational Insights
* **The Wait-Time Threshold:** Data analysis establishes a critical inflection point: when patient wait times cross the **35-minute threshold**, patient satisfaction scores consistently drop below 4.5/10. 
* **Staffing Inefficiencies:** Patient volume peaks heavily during PM shift windows across General Practice and Orthopedics, creating severe localized throughput delays. Shift scheduling should be dynamically adjusted to increase coverage during these hours.
* **Targeted Department Fixes:** Combining SQL subqueries with Power BI visual patterns isolates specific departments that routinely exceed average system wait times, providing clear targets for clinical process improvement.

---
*Developed by [Fazil RM](https://github.com/Fazil-RM) - Specialized in Applied Data Analytics and Operational Business Intelligence.*
