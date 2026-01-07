-- Total encounters per patient
SELECT patient_id, COUNT(*) AS total_encounters
FROM Encounters
GROUP BY patient_id;

-- Most common diagnoses
SELECT diagnosis_description, COUNT(*) AS frequency
FROM Diagnoses
GROUP BY diagnosis_description
ORDER BY frequency DESC;

-- Average cost per encounter
SELECT AVG(total_cost) AS avg_cost
FROM Billing;

-- Encounters by provider specialty
SELECT p.specialty, COUNT(e.encounter_id) AS encounters
FROM Providers p
JOIN Encounters e ON p.provider_id = e.provider_id
GROUP BY p.specialty;
