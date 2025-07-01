CREATE DATABASE IB_Revenue;

USE IB_Revenue;

SELECT * FROM investment_banking_revenue_dataset;
SELECT * FROM investment_banking_client_profiles;

-------------------- 1) WHICH REGIONS GENERATED THE HIGHEST REVENUE BY DEAL TYPE? -----------------------------
-- We can as well Join deals and clients to bring in client industry if needed for deeper context
SELECT 
    r.region,
    r.deal_type,
    ROUND(SUM(r.revenue_usd),2) AS total_revenue
FROM 
   investment_banking_revenue_dataset r
LEFT JOIN
    investment_banking_client_profiles c
ON
    r.client_name = c.client_name
GROUP BY 
    r.region, r.deal_type
ORDER BY 
    total_revenue DESC;

----------------------- 2) WHO ARE THE TOP 10 HIGHEST REVENUE GENERATING CLIENTS, AND WHAT ARE THEIR INDUSTRIES? ----------
SELECT
    r.client_name,
    c.industry,
    SUM(r.revenue_usd) AS total_revenue
FROM
    investment_banking_revenue_dataset r
LEFT JOIN
    investment_banking_client_profiles c
ON
    r.client_name = c.client_name
GROUP BY
    r.client_name, c.industry
ORDER BY
    total_revenue DESC
LIMIT 10;

----------------- 3) HOW DOES AVERAGE DEAL SIZE DIFFER BY RELATIONSHIP TIER ACROSS SECTORS? ------------------
SELECT
    r.relationship_tier,
    r.sector,
    COUNT(*) AS num_deals,
    ROUND(AVG(r.revenue_usd),3) AS avg_deal_size
FROM
    investment_banking_revenue_dataset r
GROUP BY
    r.relationship_tier, r.sector
ORDER BY
    r.relationship_tier, avg_deal_size DESC;

-------------------- 4) WHICH CLIENT INDUSTRIES CONTRIBUTE THE MOST REVENUE OVERALL?-----------------------
SELECT
    c.industry,
    ROUND(SUM(r.revenue_usd),2) AS total_revenue
FROM
    investment_banking_revenue_dataset r
LEFT JOIN
    investment_banking_client_profiles c
ON
    r.client_name = c.client_name
GROUP BY
    c.industry
ORDER BY
    total_revenue DESC;
    
 ----------- 5) YEARLY REVENUE TRENDS ACROSS REGIONS — WHERE ARE WE GROWING FASTEST? ------------------
SELECT
    YEAR(STR_TO_DATE(r.deal_date, '%m/%d/%Y')) AS year,
    r.region,
    ROUND(SUM(r.revenue_usd), 2) AS annual_revenue
FROM
    investment_banking_revenue_dataset r
WHERE
    r.deal_date IS NOT NULL
GROUP BY
    year, r.region
ORDER BY
    year, annual_revenue DESC
LIMIT 60;

--------  6) WHICH SECTOR AND DEAL TYPE BRING IN THE HIGHEST AVERAGE REVENUE PER DEAL?--------------------
SELECT
    r.sector,
    r.deal_type,
    COUNT(*) AS num_deals,
    AVG(r.revenue_usd) AS avg_revenue_per_deal
FROM
    investment_banking_revenue_dataset r
GROUP BY
    r.sector, r.deal_type
ORDER BY
    avg_revenue_per_deal DESC;
    
-----------------  7) CLIENTS WITH DEALS ABOVE THEIR SECTORS REVENUE? -----------------------
SELECT 
  r.client_name,
  r.sector,
  r.revenue_usd,
  c.industry
FROM investment_banking_revenue_dataset r
LEFT JOIN investment_banking_client_profiles c ON r.client_name = c.client_name
WHERE r.revenue_usd > (
  SELECT AVG(r2.revenue_usd)
  FROM investment_banking_revenue_dataset r2
  WHERE r2.sector = r.sector
)
ORDER BY r.sector, r.revenue_usd DESC;




