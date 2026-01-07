-- Total patients
SELECT COUNT(DISTINCT patient_id) AS total_patients
FROM patients;

-- Gender distribution
SELECT gender, COUNT(*) AS count
FROM patients
GROUP BY gender;

-- Age group distribution
SELECT 
  CASE 
    WHEN age < 18 THEN 'Under 18'
    WHEN age BETWEEN 18 AND 35 THEN '18-35'
    WHEN age BETWEEN 36 AND 55 THEN '36-55'
    ELSE '55+'
  END AS age_group,
  COUNT(*) AS patient_count
FROM patients
GROUP BY age_group;

-- Top diagnoses
SELECT diagnosis, COUNT(*) AS diagnosis_count
FROM diagnoses
GROUP BY diagnosis
ORDER BY diagnosis_count DESC
LIMIT 10;
