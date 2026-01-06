/* 
EHR SQL Analysis (Synthea-style dataset)
Tables expected:
- patients (from patients.csv)
- encounters (from encounters.csv)
- conditions (from conditions.csv)

NOTE: Do not use sensitive identifier columns like SSN or DRIVERS in analysis.
*/

-- 1) Total patients
SELECT COUNT(*) AS total_patients
FROM patients;

-- 2) Patients by gender
SELECT GENDER, COUNT(*) AS patient_count
FROM patients
GROUP BY GENDER
ORDER BY patient_count DESC;

-- 3) Age (approx) using BIRTHDATE
-- This version is for SQLite. If you use a different SQL engine, tell me and I’ll adjust.
SELECT
  CASE
    WHEN (CAST(strftime('%Y', 'now') AS INT) - CAST(strftime('%Y', BIRTHDATE) AS INT)) < 18 THEN 'Under 18'
    WHEN (CAST(strftime('%Y', 'now') AS INT) - CAST(strftime('%Y', BIRTHDATE) AS INT)) BETWEEN 18 AND 35 THEN '18-35'
    WHEN (CAST(strftime('%Y', 'now') AS INT) - CAST(strftime('%Y', BIRTHDATE) AS INT)) BETWEEN 36 AND 55 THEN '36-55'
    ELSE '55+'
  END AS age_group,
  COUNT(*) AS patient_count
FROM patients
GROUP BY age_group
ORDER BY patient_count DESC;

-- 4) Deceased vs Alive (based on DEATHDATE)
SELECT
  CASE WHEN DEATHDATE IS NULL OR DEATHDATE = '' THEN 'Alive' ELSE 'Deceased' END AS vital_status,
  COUNT(*) AS patient_count
FROM patients
GROUP BY vital_status;

-- 5) Patients by race / ethnicity (if columns exist in your file)
-- If RACE/ETHNICITY aren't present, skip these queries.
SELECT RACE, COUNT(*) AS patient_count
FROM patients
GROUP BY RACE
ORDER BY patient_count DESC;

SELECT ETHNICITY, COUNT(*) AS patient_count
FROM patients
GROUP BY ETHNICITY
ORDER BY patient_count DESC;

-- 6) Top conditions (requires conditions.csv loaded as table 'conditions')
-- Column names vary. After you paste the first 5 headers from conditions.csv, I’ll finalize this query.
-- SELECT DESCRIPTION, COUNT(*) AS condition_count
-- FROM conditions
-- GROUP BY DESCRIPTION
-- ORDER BY condition_count DESC
-- LIMIT 10;

-- 7) Visits per month (requires encounters.csv loaded as table 'encounters')
-- Column names vary. After you paste the first 5 headers from encounters.csv, I’ll finalize this query.
-- SELECT strftime('%Y-%m', START) AS visit_month, COUNT(*) AS visit_count
-- FROM encounters
-- GROUP BY visit_month
-- ORDER BY visit_month;

/* =========================
   ENCOUNTERS ANALYSIS
   Table: encounters (from encounters.csv)
   Columns: Id, START, STOP, PATIENT, ENCOUNTERCLASS, DESCRIPTION, TOTAL_CLAIM_COST, PAYER_COVERAGE, etc.
   ========================= */

-- 8) Total encounters (visits)
SELECT COUNT(*) AS total_encounters
FROM encounters;

-- 9) Encounters per month (visit trends)
-- START is an ISO datetime, so we can group by YYYY-MM
SELECT
  substr(START, 1, 7) AS visit_month,
  COUNT(*) AS visit_count
FROM encounters
GROUP BY visit_month
ORDER BY visit_month;

-- 10) Encounters by class (e.g., outpatient, inpatient, emergency)
SELECT
  ENCOUNTERCLASS,
  COUNT(*) AS encounter_count
FROM encounters
GROUP BY ENCOUNTERCLASS
ORDER BY encounter_count DESC;

-- 11) Top 10 encounter descriptions
SELECT
  DESCRIPTION,
  COUNT(*) AS encounter_count
FROM encounters
GROUP BY DESCRIPTION
ORDER BY encounter_count DESC
LIMIT 10;

-- 12) Average and total claim cost (overall)
SELECT
  ROUND(AVG(TOTAL_CLAIM_COST), 2) AS avg_total_claim_cost,
  ROUND(SUM(TOTAL_CLAIM_COST), 2) AS sum_total_claim_cost
FROM encounters;

-- 13) Claim cost by encounter class
SELECT
  ENCOUNTERCLASS,
  ROUND(AVG(TOTAL_CLAIM_COST), 2) AS avg_claim_cost,
  ROUND(SUM(TOTAL_CLAIM_COST), 2) AS total_claim_cost
FROM encounters
GROUP BY ENCOUNTERCLASS
ORDER BY total_claim_cost DESC;

/* =========================
   CONDITIONS (DIAGNOSES) ANALYSIS
   Table: conditions (from conditions.csv)
   Columns: START, STOP, PATIENT, ENCOUNTER, SYSTEM, CODE, DESCRIPTION
   ========================= */

-- 14) Total condition records
SELECT COUNT(*) AS total_condition_records
FROM conditions;

-- 15) Top 10 diagnoses (by frequency)
SELECT
  DESCRIPTION,
  COUNT(*) AS diagnosis_count
FROM conditions
GROUP BY DESCRIPTION
ORDER BY diagnosis_count DESC
LIMIT 10;

-- 16) Diagnoses per month (trend)
SELECT
  substr(START, 1, 7) AS condition_month,
  COUNT(*) AS condition_count
FROM conditions
GROUP BY condition_month
ORDER BY condition_month;

-- 17) Top 10 diagnoses with average claim cost (join conditions + encounters)
-- Joins by ENCOUNTER = encounters.Id
SELECT
  c.DESCRIPTION,
  COUNT(*) AS diagnosis_count,
  ROUND(AVG(e.TOTAL_CLAIM_COST), 2) AS avg_claim_cost
FROM conditions c
JOIN encounters e
  ON c.ENCOUNTER = e.Id
GROUP BY c.DESCRIPTION
ORDER BY diagnosis_count DESC
LIMIT 10;

-- 18) Encounter class breakdown for diagnoses (join conditions + encounters)
SELECT
  e.ENCOUNTERCLASS,
  COUNT(*) AS condition_records
FROM conditions c
JOIN encounters e
  ON c.ENCOUNTER = e.Id
GROUP BY e.ENCOUNTERCLASS
ORDER BY condition_records DESC;
