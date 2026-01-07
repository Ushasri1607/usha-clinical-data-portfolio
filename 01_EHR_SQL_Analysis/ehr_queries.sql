-- ================================
-- BASIC COUNTS
-- ================================
SELECT COUNT(*) AS total_patients FROM patients;
SELECT COUNT(*) AS total_encounters FROM encounters;
SELECT COUNT(*) AS total_conditions FROM conditions;

-- ================================
-- ENCOUNTER CLASS DISTRIBUTION
-- ================================
SELECT
  ENCOUNTERCLASS,
  COUNT(*) AS encounter_count
FROM encounters
GROUP BY ENCOUNTERCLASS
ORDER BY encounter_count DESC;

-- ================================
-- ENCOUNTERS OVER TIME
-- ================================
SELECT
  DATE_FORMAT(START, '%Y-%m-01') AS month,
  COUNT(*) AS encounters
FROM encounters
GROUP BY month
ORDER BY month;

-- ================================
-- TOP DIAGNOSES (ICD-10)
-- ================================
SELECT
  CODE,
  DESCRIPTION,
  COUNT(*) AS diagnosis_count
FROM conditions
GROUP BY CODE, DESCRIPTION
ORDER BY diagnosis_count DESC
LIMIT 10;

-- ================================
-- PATIENT AGE GROUPS
-- ================================
SELECT
  CASE
    WHEN TIMESTAMPDIFF(YEAR, BIRTHDATE, CURDATE()) < 18 THEN '0-17'
    WHEN TIMESTAMPDIFF(YEAR, BIRTHDATE, CURDATE()) <= 34 THEN '18-34'
    WHEN TIMESTAMPDIFF(YEAR, BIRTHDATE, CURDATE()) <= 49 THEN '35-49'
    WHEN TIMESTAMPDIFF(YEAR, BIRTHDATE, CURDATE()) <= 64 THEN '50-64'
    ELSE '65+'
  END AS age_group,
  COUNT(*) AS patient_count
FROM patients
GROUP BY age_group;

-- ================================
-- HIGH UTILIZATION PATIENTS
-- ================================
SELECT
  PATIENT,
  COUNT(*) AS encounter_count
FROM encounters
GROUP BY PATIENT
ORDER BY encounter_count DESC
LIMIT 10;

-- ================================
-- 30-DAY RETURN VISIT PROXY
-- ================================
WITH ordered AS (
  SELECT
    PATIENT,
    START,
    LAG(START) OVER (PARTITION BY PATIENT ORDER BY START) AS prev_start
  FROM encounters
)
SELECT
  PATIENT,
  START,
  prev_start,
  DATEDIFF(START, prev_start) AS days_between
FROM ordered
WHERE prev_start IS NOT NULL
  AND DATEDIFF(START, prev_start) BETWEEN 1 AND 30;
