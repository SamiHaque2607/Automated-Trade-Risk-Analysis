# main_pipeline.py

"""
Automated Trade Risk Scoring Pipeline
- Pulls cleaned macroeconomic and trade data from BigQuery
- Executes advanced SQL to generate risk scores
- Saves output to CSV for analysis or reporting
"""

from google.cloud import bigquery
import pandas as pd

# Set project ID
PROJECT_ID = "your-project-id"
client = bigquery.Client(project=PROJECT_ID)

# Load SQL from external file
with open("sql/trade_risk_score.sql", "r") as f:
    query = f.read()

# Run query and save to DataFrame
df = client.query(query).to_dataframe()

# Save results locally
df.to_csv("sample_data/sample_trade_risk_output.csv", index=False)

print("Pipeline executed and CSV saved.")
