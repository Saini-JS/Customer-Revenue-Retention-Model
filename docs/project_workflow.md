# Project Workflow

This project was built in a practical end-to-end sequence.

## Step 1 – Define the business problem
The starting point was a commercial question:
how can a retailer identify profit leakage, prioritise customer retention, and recover growth?

## Step 2 – Design the relational structure
A SQL Server schema was created to represent customers, products, sales, and complaint-linked service data.

## Step 3 – Generate synthetic data
Python was used to generate a realistic synthetic dataset with:
- customer tiers
- regional variation
- complaint behaviour
- service quality signals
- product affinity
- churn-related signals

## Step 4 – Build semantic SQL views
Reusable SQL views were created to translate raw structures into analysis-ready layers.

These views supported:
- customer-level commercial analysis
- complaint-linked revenue leakage
- time intelligence
- market basket analysis
- retention action prioritisation

## Step 5 – Score churn probability
Python was then used to build a churn propensity workflow so customers could be prioritised for intervention.

## Step 6 – Build Tableau dashboards
Two dashboards were built:

- Dashboard 1 for executive financial visibility
- Dashboard 2 for operational action and customer retention

## Step 7 – Package the work for portfolio presentation
The final project was structured for GitHub so it could be reviewed by recruiters, hiring managers, and interviewers in a clear and credible way.
