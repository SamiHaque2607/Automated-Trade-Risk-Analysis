# Automated-Trade-Risk-Analysis

# Global Trade Risk Tracker

This project analyses UK import exposure to global macroeconomic risks by integrating trade data and macroeconomic indicators using SQL (BigQuery) and Python automation. It generates a composite Trade Risk Score based on GDP, inflation, and current account data to help businesses understand their import vulnerabilities.

## Project Overview

- Data Sources:
  - UK Import Trade Data (BigQuery Public Dataset)
  - IMF World Economic Outlook (World Bank API)
  - Country ISO Codes

- Technologies Used:
  - Google BigQuery (advanced SQL)
  - Python for API automation and BigQuery integration
  - GitHub for version control and sharing
  - Optional scheduling via Cloud Scheduler or cron

## Methodology

### Step 1: Clean and transform macroeconomic data
- Extract 2023 GDP (USD), inflation, and current account balance using SQL.
- Filter and reshape using CASE WHEN + GROUP BY.

### Step 2: Merge with import data
- Join UK imports by ISO country codes.
- Calculate import value as a percentage of GDP.

### Step 3: Standardise metrics
- Normalise import %, inflation, and current account values using Z-scores.

### Step 4: Generate Trade Risk Score
- Composite score:
  trade_risk_score = 0.5*z_import + 0.3*z_inflation - 0.2*z_account

### Step 5: Add risk bands
- Extreme Risk, High Risk, Moderate, Low Risk — based on threshold cutoffs.

## Sample Output

Click below to view the full trade risk output CSV:

[View sample_trade_risk_output.csv](./sample_trade_risk_output.csv)


## Automation (Python)

- Connects to BigQuery.
- Runs the pipeline weekly.
- Optionally fetches macroeconomic updates via World Bank API.

To run:

```
python main_pipeline.py
```

## File Descriptions

| File                                       | Purpose                                               |
|--------------------------------------------|-------------------------------------------------------|
| `main_pipeline.py`                         | Full Python script to run the SQL pipeline & save CSV |
| `sql/trade_risk_score.sql`                 | SQL script that computes Trade Risk Score             |
| `sample_trade_risk_output.csv` | Example output                                        |
| `requirements.txt`                         | Required Python libraries                             |

## Future Improvements

- Connect live IMF/World Bank API for monthly macro updates
- Add frontend dashboard via Tableau
- Build alert system when a country risk score exceeds threshold
