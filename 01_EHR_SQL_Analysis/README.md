## EHR Data Analysis using SQL

### Project Overview
This project analyzes de-identified EHR-style healthcare data to identify patient demographics, visit trends, and common clinical conditions. The goal is to demonstrate practical SQL skills and healthcare data understanding for Clinical Data Analyst and Health Informatics roles.

### Tools Used
- SQL (SQLite / SQL Server)
- Excel (data review)
- GitHub

### Dataset
This analysis uses a synthetic EHR dataset generated using Synthea.
The dataset is HIPAA-safe and contains no real patient information.

### Key Questions Answered
1. How many patients are in the dataset?
2. What are the most common diagnoses?
3. How do patient visits trend over time?
4. What is the age group distribution?
5. What is the gender distribution?
6. Which diagnoses have the highest average claim cost?

### Files in This Folder
- ehr_queries.sql – SQL queries used for analysis
- Insights_Summary.md – Key findings and insights
- images/ – Charts and tables
- dataset/

### Key Learnings
- Writing SQL queries for healthcare data
- Understanding clinical datasets
- Ensuring HIPAA-safe data handling

### Privacy Note
Although this dataset is synthetic, the raw files include identifier-like columns (e.g., SSN, DRIVERS). These fields are not used in any analysis and should be removed if sharing outside this repository.
