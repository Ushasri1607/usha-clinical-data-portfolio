-- Patients table
CREATE TABLE Patients (
    patient_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    gender TEXT,
    date_of_birth DATE
);

-- Providers table
CREATE TABLE Providers (
    provider_id INTEGER PRIMARY KEY,
    provider_name TEXT,
    specialty TEXT
);

-- Encounters table
CREATE TABLE Encounters (
    encounter_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    provider_id INTEGER,
    encounter_date DATE,
    encounter_type TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);

-- Diagnoses table
CREATE TABLE Diagnoses (
    diagnosis_id INTEGER PRIMARY KEY,
    encounter_id INTEGER,
    diagnosis_code TEXT,
    diagnosis_description TEXT,
    FOREIGN KEY (encounter_id) REFERENCES Encounters(encounter_id)
);

-- Billing table
CREATE TABLE Billing (
    billing_id INTEGER PRIMARY KEY,
    encounter_id INTEGER,
    total_cost REAL,
    payer TEXT,
    FOREIGN KEY (encounter_id) REFERENCES Encounters(encounter_id)
);
