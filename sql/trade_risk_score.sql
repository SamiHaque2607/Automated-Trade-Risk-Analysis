-- trade_risk_score.sql

-- Step 1: Compute trade exposure (% of GDP)
WITH trade_exposure AS (
  SELECT
    c.country_name,
    i.cifvalue AS import_value,
    m.gdp_usd,
    m.inflation,
    m.current_account_pct_gdp,
    ROUND(i.cifvalue / m.gdp_usd * 100, 2) AS import_pct_gdp
  FROM `trade_risk_project.uk_imports_2023` i
  JOIN `trade_risk_project.country_codes` c
    ON i.partnerISO = c.iso3
  JOIN `trade_risk_project.cleaned_macro` m
    ON c.country_name = m.Country
  WHERE i.cifvalue IS NOT NULL AND m.gdp_usd IS NOT NULL
),

-- Step 2: Normalise metrics using Z-scores
normalised_scores AS (
  SELECT
    *,
    (import_pct_gdp - AVG(import_pct_gdp) OVER()) / STDDEV(import_pct_gdp) OVER() AS z_import,
    (inflation - AVG(inflation) OVER()) / STDDEV(inflation) OVER() AS z_inflation,
    (current_account_pct_gdp - AVG(current_account_pct_gdp) OVER()) / STDDEV(current_account_pct_gdp) OVER() AS z_account
  FROM trade_exposure
),

-- Step 3: Composite Trade Risk Score
composite_score AS (
  SELECT
    country_name,
    import_value,
    gdp_usd,
    inflation,
    current_account_pct_gdp,
    import_pct_gdp,
    ROUND((z_import * 0.5 + z_inflation * 0.3 - z_account * 0.2), 2) AS trade_risk_score
  FROM normalised_scores
),

-- Step 4: Correlation between import % and inflation
correlation AS (
  SELECT CORR(import_pct_gdp, inflation) AS exposure_inflation_corr
  FROM composite_score
)

-- Final Output
SELECT cs.*,
       corr.exposure_inflation_corr,
       CASE
         WHEN trade_risk_score > 1.5 THEN 'Extreme Risk'
         WHEN trade_risk_score > 0.5 THEN 'High Risk'
         WHEN trade_risk_score > -0.5 THEN 'Moderate'
         ELSE 'Low Risk'
       END AS risk_band
FROM composite_score cs, correlation corr
ORDER BY trade_risk_score DESC;
