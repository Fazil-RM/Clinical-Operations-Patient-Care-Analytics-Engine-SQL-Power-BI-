-- =========================================================================
-- HEALTHCARE PATIENTS ANALYTICS: DATA CLEANING & PERFORMANCE ANALYSIS
-- Database: healthcare_analytics
-- Target Table: hospital_patients
-- =========================================================================

USE healthcare_analytics;

-- =========================================================================
-- PART 1: DATA CLEANING, EXPLORATION & DEMOGRAPHICS (Queries 1 - 18)
-- =========================================================================

-- Q01: Preview first 10 records of the dataset
SELECT *
FROM hospital_patients
LIMIT 10;

-- Q02: Inspect column names and system data types
DESCRIBE hospital_patients;

-- Q03: Retrieve total recorded patient visits
SELECT COUNT(*) AS total_patients
FROM hospital_patients;

-- Q04: Identify duplicate patient records
SELECT 
    patient_id, 
    COUNT(*) AS duplicate_count
FROM hospital_patients
GROUP BY patient_id
HAVING COUNT(*) > 1;

-- Q05: Identify missing values (NULLs) in critical clinical and operational columns
SELECT
    SUM(patient_id IS NULL) AS missing_patient_id,
    SUM(patient_gender IS NULL) AS missing_gender,
    SUM(patient_age IS NULL) AS missing_age,
    SUM(patient_waittime IS NULL) AS missing_waittime,
    SUM(patient_sat_score IS NULL) AS missing_satisfaction,
    SUM(department_referral IS NULL) AS missing_department,
    SUM(admission_flag IS NULL) AS missing_admission,
    SUM(visit_shift IS NULL) AS missing_shift
FROM hospital_patients;

-- Q06: Audit age column for statistical anomalies or impossible values
SELECT 
    patient_id, 
    full_name, 
    patient_age
FROM hospital_patients
WHERE patient_age < 0 OR patient_age > 120;

-- Q07: Audit waiting times for negative duration anomalies
SELECT 
    patient_id, 
    full_name, 
    patient_waittime
FROM hospital_patients
WHERE patient_waittime < 0;

-- Q08: Find the temporal range (start and end dates) of the dataset
SELECT
    MIN(STR_TO_DATE(visit_date, '%d-%b-%y')) AS first_visit,
    MAX(STR_TO_DATE(visit_date, '%d-%b-%y')) AS last_visit
FROM hospital_patients;

-- Q09: Calculate total patient volume by referral department (including "None")
SELECT
    department_referral,
    COUNT(*) AS total_patients
FROM hospital_patients
GROUP BY department_referral
ORDER BY total_patients DESC;

-- Q10: Calculate total patient volume excluding internal "None" referrals
SELECT
    department_referral,
    COUNT(*) AS total_patients
FROM hospital_patients
WHERE department_referral <> 'None'
GROUP BY department_referral
ORDER BY total_patients DESC;

-- Q11: Analyze demographic breakdown and share of patient gender
SELECT
    patient_gender,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hospital_patients), 2) AS percentage
FROM hospital_patients
GROUP BY patient_gender
ORDER BY total_patients DESC;

-- Q12: Calculate patient age summary statistics
SELECT
    ROUND(AVG(patient_age), 2) AS average_age,
    MIN(patient_age) AS youngest_patient,
    MAX(patient_age) AS oldest_patient
FROM hospital_patients;

-- Q13: Identify statistical mode (most frequent ages) in the patient population
SELECT
    patient_age,
    COUNT(*) AS patient_count
FROM hospital_patients
GROUP BY patient_age
ORDER BY patient_count DESC, patient_age;

-- Q14: Segment patient cohort into standardized demographic age groups
SELECT
    CASE
        WHEN patient_age <= 18 THEN '0-18'
        WHEN patient_age <= 35 THEN '19-35'
        WHEN patient_age <= 50 THEN '36-50'
        WHEN patient_age <= 65 THEN '51-65'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hospital_patients), 2) AS percentage
FROM hospital_patients
GROUP BY age_group
ORDER BY total_patients DESC;

-- Q15: Calculate hospital-wide wait time summary statistics
SELECT
    ROUND(AVG(patient_waittime), 2) AS average_wait,
    MIN(patient_waittime) AS minimum_wait,
    MAX(patient_waittime) AS maximum_wait
FROM hospital_patients;

-- Q16: Identify the top 10 patient cases with the longest wait times
SELECT
    patient_id,
    full_name,
    department_referral,
    patient_waittime
FROM hospital_patients
ORDER BY patient_waittime DESC
LIMIT 10;

-- Q17: Analyze workload distribution across different work shifts
SELECT
    visit_shift,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hospital_patients), 2) AS percentage
FROM hospital_patients
GROUP BY visit_shift
ORDER BY total_patients DESC;

-- Q18: Analyze the frequency distribution of patient satisfaction scores
SELECT
    patient_sat_score,
    COUNT(*) AS total_patients
FROM hospital_patients
WHERE patient_sat_score IS NOT NULL
GROUP BY patient_sat_score
ORDER BY patient_sat_score;


-- =========================================================================
-- PART 2: INTERMEDIATE OPERATIONAL PERFORMANCE ANALYTICS (Queries 19 - 35)
-- =========================================================================

-- Q19: Department performance scorecard (volume, average wait, and satisfaction metrics)
SELECT
    department_referral,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_waittime), 2) AS avg_wait_time,
    ROUND(AVG(patient_sat_score), 2) AS avg_satisfaction,
    MIN(patient_waittime) AS minimum_wait,
    MAX(patient_waittime) AS maximum_wait
FROM hospital_patients
WHERE department_referral <> 'None'
GROUP BY department_referral
ORDER BY total_patients DESC;

-- Q20: Highlight departments exhibiting the highest average wait times
SELECT
    department_referral,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_waittime), 2) AS average_wait_time
FROM hospital_patients
WHERE department_referral <> 'None'
GROUP BY department_referral
ORDER BY average_wait_time DESC;

-- Q21: Identify departments with top patient satisfaction scores
SELECT
    department_referral,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction
FROM hospital_patients
WHERE department_referral <> 'None'
  AND patient_sat_score IS NOT NULL
GROUP BY department_referral
ORDER BY average_satisfaction DESC;

-- Q22: Analyze potential gender bias in average operational wait times
SELECT
    patient_gender,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_waittime), 2) AS average_wait_time,
    MIN(patient_waittime) AS shortest_wait,
    MAX(patient_waittime) AS longest_wait
FROM hospital_patients
GROUP BY patient_gender
ORDER BY average_wait_time DESC;

-- Q23: Compare average satisfaction score variation across gender cohorts
SELECT
    patient_gender,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction
FROM hospital_patients
WHERE patient_sat_score IS NOT NULL
GROUP BY patient_gender
ORDER BY average_satisfaction DESC;

-- Q24: Evaluate shift-based bottlenecks using patient volumes and wait times
SELECT
    visit_shift,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_waittime), 2) AS average_wait_time,
    MIN(patient_waittime) AS minimum_wait,
    MAX(patient_waittime) AS maximum_wait
FROM hospital_patients
GROUP BY visit_shift
ORDER BY total_patients DESC;

-- Q25: Determine shift performance from the perspective of patient satisfaction
SELECT
    visit_shift,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction
FROM hospital_patients
WHERE patient_sat_score IS NOT NULL
GROUP BY visit_shift
ORDER BY average_satisfaction DESC;

-- Q26: Segment wait-time and satisfaction metrics by age bracket
SELECT
    CASE
        WHEN patient_age <= 18 THEN '0-18'
        WHEN patient_age <= 35 THEN '19-35'
        WHEN patient_age <= 50 THEN '36-50'
        WHEN patient_age <= 65 THEN '51-65'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_waittime), 2) AS average_wait_time,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction
FROM hospital_patients
GROUP BY age_group
ORDER BY average_wait_time DESC;

-- Q27: Evaluate department choice and metrics segmented by age demographic
SELECT
    CASE
        WHEN patient_age <= 18 THEN '0-18'
        WHEN patient_age <= 35 THEN '19-35'
        WHEN patient_age <= 50 THEN '36-50'
        WHEN patient_age <= 65 THEN '51-65'
        ELSE '65+'
    END AS age_group,
    department_referral,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_waittime), 2) AS average_wait,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction
FROM hospital_patients
WHERE department_referral <> 'None'
GROUP BY age_group, department_referral
ORDER BY age_group, total_patients DESC;

-- Q28: Highlight department volume share relative to total hospital visits
SELECT
    department_referral,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hospital_patients), 2) AS patient_percentage
FROM hospital_patients
WHERE department_referral <> 'None'
GROUP BY department_referral
ORDER BY patient_percentage DESC;

-- Q29: Compare key metrics between patients admitted vs. those discharged directly
SELECT
    admission_flag,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_waittime), 2) AS average_wait_time,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction
FROM hospital_patients
GROUP BY admission_flag
ORDER BY total_patients DESC;

-- Q30: Flag patients experiencing wait times above the hospital-wide mean
SELECT
    patient_id,
    full_name,
    department_referral,
    patient_waittime
FROM hospital_patients
WHERE patient_waittime > (SELECT AVG(patient_waittime) FROM hospital_patients)
ORDER BY patient_waittime DESC;

-- Q31: Detect departments with average wait times exceeding the facility-wide average
SELECT
    department_referral,
    ROUND(AVG(patient_waittime), 2) AS average_wait_time
FROM hospital_patients
WHERE department_referral <> 'None'
GROUP BY department_referral
HAVING AVG(patient_waittime) > (SELECT AVG(patient_waittime) FROM hospital_patients)
ORDER BY average_wait_time DESC;

-- Q32: Identify departments underperforming compared to overall hospital satisfaction
SELECT
    department_referral,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction
FROM hospital_patients
WHERE department_referral <> 'None'
  AND patient_sat_score IS NOT NULL
GROUP BY department_referral
HAVING AVG(patient_sat_score) < (
    SELECT AVG(patient_sat_score)
    FROM hospital_patients
    WHERE patient_sat_score IS NOT NULL
)
ORDER BY average_satisfaction;

-- Q33: Segment patient volume into defined Service Level Agreement (SLA) categories
SELECT
    CASE
        WHEN patient_waittime < 15 THEN 'Excellent (<15 mins)'
        WHEN patient_waittime < 30 THEN 'Good (15-29 mins)'
        WHEN patient_waittime < 60 THEN 'Average (30-59 mins)'
        ELSE 'Critical (60+ mins)'
    END AS wait_category,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hospital_patients), 2) AS percentage
FROM hospital_patients
GROUP BY wait_category
ORDER BY total_patients DESC;

-- Q34: Correlate patient satisfaction with service levels (wait tiers)
SELECT
    CASE
        WHEN patient_waittime < 15 THEN 'Excellent'
        WHEN patient_waittime < 30 THEN 'Good'
        WHEN patient_waittime < 60 THEN 'Average'
        ELSE 'Critical'
    END AS wait_category,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction
FROM hospital_patients
WHERE patient_sat_score IS NOT NULL
GROUP BY wait_category
ORDER BY average_satisfaction DESC;

-- Q35: Identify departments exceeding average performance in both metrics (low wait & high satisfaction)
WITH department_summary AS (
    SELECT
        department_referral,
        COUNT(*) AS total_patients,
        AVG(patient_waittime) AS average_wait,
        AVG(patient_sat_score) AS average_satisfaction
    FROM hospital_patients
    WHERE department_referral <> 'None'
      AND patient_sat_score IS NOT NULL
    GROUP BY department_referral
)
SELECT
    department_referral,
    total_patients,
    ROUND(average_wait, 2) AS average_wait,
    ROUND(average_satisfaction, 2) AS average_satisfaction
FROM department_summary
WHERE average_wait < (SELECT AVG(patient_waittime) FROM hospital_patients)
  AND average_satisfaction > (
      SELECT AVG(patient_sat_score)
      FROM hospital_patients
      WHERE patient_sat_score IS NOT NULL
  )
ORDER BY average_satisfaction DESC, average_wait ASC;


-- =========================================================================
-- PART 3: ADVANCED ANALYTICAL WINDOW FUNCTIONS & BUSINESS KPIS (Queries 36 - 50)
-- =========================================================================

-- Q36: Rank referral departments based on historical patient volume
SELECT
    department_referral,
    COUNT(*) AS total_patients,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS department_rank
FROM hospital_patients
WHERE department_referral <> 'None'
GROUP BY department_referral;

-- Q37: Rank departments by average waiting times using DENSE_RANK()
SELECT
    department_referral,
    ROUND(AVG(patient_waittime), 2) AS average_wait_time,
    DENSE_RANK() OVER (ORDER BY AVG(patient_waittime) DESC) AS wait_rank
FROM hospital_patients
WHERE department_referral <> 'None'
GROUP BY department_referral
ORDER BY wait_rank;

-- Q38: Identify the top 3 longest-waiting patient cases within each department
WITH ranked_patients AS (
    SELECT
        patient_id,
        full_name,
        department_referral,
        patient_waittime,
        ROW_NUMBER() OVER(
            PARTITION BY department_referral
            ORDER BY patient_waittime DESC
        ) AS row_num
    FROM hospital_patients
    WHERE department_referral <> 'None'
)
SELECT *
FROM ranked_patients
WHERE row_num <= 3
ORDER BY department_referral, patient_waittime DESC;

-- Q39: Pinpoint the best patient feedback experience per department (resolving ties by lower wait time)
WITH satisfaction_rank AS (
    SELECT
        patient_id,
        full_name,
        department_referral,
        patient_sat_score,
        ROW_NUMBER() OVER(
            PARTITION BY department_referral
            ORDER BY patient_sat_score DESC, patient_waittime ASC
        ) AS rn
    FROM hospital_patients
    WHERE patient_sat_score IS NOT NULL
      AND department_referral <> 'None'
)
SELECT *
FROM satisfaction_rank
WHERE rn = 1
ORDER BY department_referral;

-- Q40: Categorize departments into workload intensity quartiles
WITH department_volume AS (
    SELECT
        department_referral,
        COUNT(*) AS total_patients
    FROM hospital_patients
    WHERE department_referral <> 'None'
    GROUP BY department_referral
)
SELECT
    department_referral,
    total_patients,
    NTILE(4) OVER(ORDER BY total_patients DESC) AS workload_quartile
FROM department_volume;

-- Q41: Calculate departmental volume share percentage using advanced window functions
SELECT
    department_referral,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS contribution_percentage
FROM hospital_patients
WHERE department_referral <> 'None'
GROUP BY department_referral
ORDER BY contribution_percentage DESC;

-- Q42: Contextualize department wait times against facility averages using window categorization
WITH department_wait AS (
    SELECT
        department_referral,
        ROUND(AVG(patient_waittime), 2) AS average_wait
    FROM hospital_patients
    WHERE department_referral <> 'None'
    GROUP BY department_referral
)
SELECT
    department_referral,
    average_wait,
    CASE
        WHEN average_wait > (SELECT AVG(patient_waittime) FROM hospital_patients) THEN 'Above Hospital Average'
        ELSE 'Below Hospital Average'
    END AS performance_status
FROM department_wait
ORDER BY average_wait DESC;

-- Q43: Formulate a combined performance index KPI (Weighted score = Satisfaction - Wait/10)
SELECT
    department_referral,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_waittime), 2) AS average_wait,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction,
    ROUND(AVG(patient_sat_score) - (AVG(patient_waittime) / 10.0), 2) AS performance_score
FROM hospital_patients
WHERE department_referral <> 'None'
  AND patient_sat_score IS NOT NULL
GROUP BY department_referral
ORDER BY performance_score DESC;

-- Q44: Map patient experiences into a cumulative distribution (CUME_DIST) of wait times
SELECT
    patient_id,
    full_name,
    department_referral,
    patient_waittime,
    ROUND(CUME_DIST() OVER(ORDER BY patient_waittime), 3) AS wait_percentile
FROM hospital_patients
ORDER BY patient_waittime DESC;

-- Q45: Map patient experiences to a percentage rank context based on waiting times
SELECT
    patient_id,
    full_name,
    department_referral,
    patient_waittime,
    ROUND(PERCENT_RANK() OVER(ORDER BY patient_waittime), 3) AS wait_rank_percentage
FROM hospital_patients
ORDER BY patient_waittime DESC;

-- Q46: Calculate running cumulative total of patient admissions over time
WITH daily_visits AS (
    SELECT
        STR_TO_DATE(visit_date, '%d-%b-%y') AS visit_day,
        COUNT(*) AS daily_patients
    FROM hospital_patients
    GROUP BY visit_day
)
SELECT
    visit_day,
    daily_patients,
    SUM(daily_patients) OVER(ORDER BY visit_day) AS cumulative_patients
FROM daily_visits
ORDER BY visit_day;

-- Q47: Generate complex KPI scorecard and performance rank by department
WITH performance AS (
    SELECT
        department_referral,
        COUNT(*) AS total_patients,
        ROUND(AVG(patient_waittime), 2) AS avg_wait,
        ROUND(AVG(patient_sat_score), 2) AS avg_satisfaction,
        ROUND(AVG(patient_sat_score) - (AVG(patient_waittime) / 10.0), 2) AS performance_score
    FROM hospital_patients
    WHERE department_referral <> 'None'
      AND patient_sat_score IS NOT NULL
    GROUP BY department_referral
)
SELECT
    *,
    RANK() OVER(ORDER BY performance_score DESC) AS overall_rank
FROM performance;

-- Q48: Operational Risk Classification based on patient wait time and poor satisfaction
SELECT
    patient_id,
    full_name,
    department_referral,
    patient_waittime,
    patient_sat_score,
    CASE
        WHEN patient_waittime >= 60 AND patient_sat_score <= 4 THEN 'High Risk'
        WHEN patient_waittime >= 30 AND patient_sat_score <= 6 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level
FROM hospital_patients
WHERE patient_sat_score IS NOT NULL
ORDER BY patient_waittime DESC, patient_sat_score;

-- Q49: Identify clinical priority areas (High Wait & Low Satisfaction) for targeted process improvements
SELECT
    department_referral,
    COUNT(*) AS total_patients,
    ROUND(AVG(patient_waittime), 2) AS average_wait,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction
FROM hospital_patients
WHERE department_referral <> 'None'
  AND patient_sat_score IS NOT NULL
GROUP BY department_referral
HAVING AVG(patient_waittime) > (SELECT AVG(patient_waittime) FROM hospital_patients)
   AND AVG(patient_sat_score) < (
       SELECT AVG(patient_sat_score)
       FROM hospital_patients
       WHERE patient_sat_score IS NOT NULL
   )
ORDER BY average_wait DESC;

-- Q50: Executive Hospital Summary KPIs (Primary data source for Power BI card visual components)
SELECT
    COUNT(*) AS total_patients,
    COUNT(DISTINCT department_referral) AS total_departments,
    ROUND(AVG(patient_age), 1) AS average_age,
    ROUND(AVG(patient_waittime), 2) AS average_wait_time,
    ROUND(AVG(patient_sat_score), 2) AS average_satisfaction,
    SUM(CASE WHEN admission_flag = 'TRUE' THEN 1 ELSE 0 END) AS total_admissions,
    MIN(patient_waittime) AS shortest_wait,
    MAX(patient_waittime) AS longest_wait
FROM hospital_patients;