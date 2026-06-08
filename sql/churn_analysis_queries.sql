-- ============================================================
-- Telecom Retention Analytics
-- SQL Analysis Queries
-- ============================================================

-- 1. Overall churn rate
SELECT
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(AVG(churn_value) * 100, 2) AS churn_rate_percent
FROM telco_churn;

-- 2. Churn by contract type
SELECT
    contract,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(AVG(churn_value) * 100, 2) AS churn_rate_percent,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_revenue,
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS monthly_revenue_lost
FROM telco_churn
GROUP BY contract
ORDER BY churn_rate_percent DESC;

-- 3. Churn by payment method
SELECT
    Payment_Method,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(AVG(churn_value) * 100, 2) AS churn_rate_percent,
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS monthly_revenue_lost
FROM telco_churn
GROUP BY Payment_Method
ORDER BY churn_rate_percent DESC;

-- 4. Churn by internet service
SELECT
    internet_service,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(AVG(churn_value) * 100, 2) AS churn_rate_percent,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge,
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS monthly_revenue_lost
FROM telco_churn
GROUP BY internet_service
ORDER BY churn_rate_percent DESC;

-- 5. Churn by tenure group
SELECT
    tenure_group,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(AVG(churn_value) * 100, 2) AS churn_rate_percent,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge,
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS monthly_revenue_lost
FROM telco_churn
GROUP BY tenure_group
ORDER BY 
    CASE tenure_group
        WHEN '0 months' THEN 1
        WHEN '1-12 months' THEN 2
        WHEN '13-24 months' THEN 3
        WHEN '25-48 months' THEN 4
        WHEN '49-72 months' THEN 5
    END;

-- 6. Churn by senior citizen status
SELECT
    senior_citizen,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(AVG(churn_value) * 100, 2) AS churn_rate_percent,
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS monthly_revenue_lost
FROM telco_churn
GROUP BY senior_citizen
ORDER BY churn_rate_percent DESC;

-- 7. Churn by support services
SELECT
    tech_support,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(AVG(churn_value) * 100, 2) AS churn_rate_percent,
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS monthly_revenue_lost
FROM telco_churn
GROUP BY tech_support
ORDER BY churn_rate_percent DESC;

-- 8. Churn reasons
SELECT
    churn_reason,
    COUNT(*) AS churned_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telco_churn WHERE churn_value = 1), 2) AS percent_of_churned_customers
FROM telco_churn
WHERE churn_value = 1
GROUP BY churn_reason
ORDER BY churned_customers DESC;

-- 9. Revenue at risk
SELECT
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS monthly_revenue_lost,
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END) * 12, 2) AS annualised_revenue_lost
FROM telco_churn;

-- 10. City-level churn hotspots
SELECT
    city,
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(AVG(churn_value) * 100, 2) AS churn_rate_percent,
    ROUND(SUM(CASE WHEN churn_value = 1 THEN monthly_charges ELSE 0 END), 2) AS monthly_revenue_lost
FROM telco_churn
GROUP BY city
HAVING COUNT(*) >= 20
ORDER BY churn_rate_percent DESC
LIMIT 15;
