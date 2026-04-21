# Python Scripts

This folder contains the Python components of the Customer Revenue Retention Model.  
These scripts generate the synthetic dataset and produce churn probabilities used by the SQL and Tableau layers.

---

## Data Injection Script

`data_generation_master.py`

This script creates the full synthetic dataset used in the project. It:

- resets all tables and identity seeds  
- loads product and customer dimensions  
- generates 25,000 sales transactions  
- applies affinity-based basket logic  
- simulates complaint behaviour and CSAT scoring  
- writes support tickets linked to sales  
- performs referential integrity checks  

The output populates all core fact and dimension tables required by the SQL semantic views.

---

## Churn Prediction Script

`churn_prediction.py`

This script trains a logistic regression model to estimate churn probability. It:

- fetches customer-level features from `vw_RetentionActionBase`  
- engineers churn-related features  
- scales inputs and trains a balanced logistic regression model  
- predicts churn probability for every customer  
- writes results back into `Fact_Churn_Predictions`  

These predictions are used in the retention dashboard to prioritise high‑risk customers.

---

## Running the Scripts

Update the SQL Server connection string in each script to match your environment:

```python
server = r'YOUR_SERVER_NAME'
database = 'Wine_Analytics_UK'
