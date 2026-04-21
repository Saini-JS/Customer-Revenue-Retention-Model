# Architecture Notes

## Project Design Principle
This project was designed as an end-to-end analytics workflow rather than a single dashboard exercise.

The architecture separates the work into clear layers:

1. source structure
2. data generation
3. analytical semantic layer
4. predictive scoring
5. stakeholder-facing dashboard layer

---

## Source Structure
The project uses a synthetic but relational SQL Server model built around:

- Dim_Customers
- Dim_Products
- Fact_Sales
- Fact_Support_Tickets

These tables form the base commercial and service dataset.

---

## Analytical Layer
Reusable SQL views were created to avoid building Tableau logic directly on top of raw fact tables.

These views include:

- customer insights
- revenue leakage
- market basket analysis
- time intelligence
- retention action base

This design keeps business logic more transparent and reusable.

---

## Python Layer
Python was used for two main tasks:

- synthetic data generation
- churn probability scoring

This reflects a practical analyst workflow where SQL handles structure and metric logic, while Python supports more flexible generation and modelling tasks.

---

## Dashboard Layer
Tableau sits on top of curated views rather than raw transactional tables.

This was done to:

- reduce repeated logic in Tableau
- keep the dashboard layer cleaner
- make the project easier to explain in interviews
- separate business logic from presentation logic

---

## Stakeholder Design
The final output was split into two dashboards:

- Dashboard 1 for executive commercial decision-making
- Dashboard 2 for operational retention action

This reflects a realistic analytics delivery pattern where different stakeholder groups need different levels of detail and different types of decisions supported.
