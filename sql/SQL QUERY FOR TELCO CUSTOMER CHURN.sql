
-- =========================================
-- VALIDATION 1: Total Customer Records
-- =========================================
SELECT COUNT(*) AS total_customers
FROM telco_churn_analysis.telco_customers;


-- =========================================
-- VALIDATION 2: Customer ID Integrity
-- =========================================
SELECT
    COUNT(DISTINCT customerID) AS unique_customers,
    SUM(
        CASE
            WHEN customerID IS NULL
                 OR TRIM(customerID) = ''
            THEN 1
            ELSE 0
        END
    ) AS missing_customer_ids
FROM telco_churn_analysis.telco_customers;


-- SHOW COLUMNS
-- FROM telco_churn_analysis.telco_customers;


ALTER TABLE telco_churn_analysis.telco_customers
RENAME COLUMN `ï»¿customerID` TO `customerID`;


-- =========================================
-- VALIDATION 3: Numerical Column Data Types
-- =========================================

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'telco_churn_analysis'
  AND TABLE_NAME = 'telco_customers'
  AND COLUMN_NAME IN (
      'tenure',
      'MonthlyCharges',
      'TotalCharges_Clean'
  );
  
  
  
  
-- =========================================
-- VALIDATION 4: Numerical Values
-- =========================================

SELECT
    'tenure' AS column_name,
    MIN(tenure) AS minimum_value,
    MAX(tenure) AS maximum_value,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS null_count
FROM telco_churn_analysis.telco_customers

UNION ALL

SELECT
    'MonthlyCharges',
    MIN(MonthlyCharges),
    MAX(MonthlyCharges),
    SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END)
FROM telco_churn_analysis.telco_customers

UNION ALL

SELECT
    'TotalCharges_Clean',
    MIN(TotalCharges_Clean),
    MAX(TotalCharges_Clean),
    SUM(CASE WHEN TotalCharges_Clean IS NULL THEN 1 ELSE 0 END)
FROM telco_churn_analysis.telco_customers;


-- =====================================================
-- QUERY 05: CONTRACT CATEGORY VALIDATION
-- Purpose: Verify customer counts by contract type
-- Business relevance: Hypothesis 1 - Contract and Churn
-- =====================================================

SELECT
    Contract AS contract_type,
    COUNT(*) AS customer_count
FROM telco_churn_analysis.telco_customers
GROUP BY Contract
ORDER BY customer_count DESC;


-- =====================================================
-- QUERY 06: CUSTOMER CHURN CLASSIFICATION VALIDATION
-- Purpose: Verify customer counts by churn status
-- Business relevance: KPI 1 - Customer Churn Rate
-- =====================================================

SELECT
    Churn AS churn_status,
    COUNT(*) AS customer_count
FROM telco_churn_analysis.telco_customers
GROUP BY Churn
ORDER BY customer_count DESC;


-- =====================================================
-- QUERY 07: INTERNET SERVICE CATEGORY VALIDATION
-- Purpose: Verify customer counts by internet service
-- Business relevance: Customer segmentation analysis
-- =====================================================

SELECT
    InternetService AS internet_service_type,
    COUNT(*) AS customer_count
FROM telco_churn_analysis.telco_customers
GROUP BY InternetService
ORDER BY customer_count DESC;


-- =====================================================
-- QUERY 08: PAYMENT METHOD CATEGORY VALIDATION
-- Purpose: Verify customer counts by payment method
-- Business relevance: Customer segmentation and churn
-- =====================================================

SELECT
    PaymentMethod AS payment_method,
    COUNT(*) AS customer_count
FROM telco_churn_analysis.telco_customers
GROUP BY PaymentMethod
ORDER BY customer_count DESC;



-- =====================================================
-- QUERY 09: OVERALL CUSTOMER CHURN ANALYSIS
-- Stage: 4.1 - KPI 1 Customer Churn Rate
-- Purpose: Calculate customer churn and retention
-- Business question: What proportion of customers left?
-- =====================================================

SELECT
    COUNT(*) AS total_customers,

    SUM(CASE
        WHEN Churn = 'Yes' THEN 1
        ELSE 0
    END) AS churned_customers,

    SUM(CASE
        WHEN Churn = 'No' THEN 1
        ELSE 0
    END) AS non_churned_customers,

    ROUND(
        100.0 * SUM(CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END) / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn_analysis.telco_customers;


-- =====================================================
-- QUERY 10: CUSTOMER CHURN RATE BY CONTRACT TYPE
-- Stage: 4.2 - KPI 2 Customer Segmentation
-- Purpose: Compare churn rates across contract types
-- Hypothesis: H1 - Month-to-month customers have
--             higher churn rates
-- =====================================================

SELECT
    Contract AS contract_type,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn_analysis.telco_customers

GROUP BY Contract

ORDER BY churn_rate_pct DESC;


-- =====================================================
-- QUERY 11: CUSTOMER CHURN RATE BY TENURE GROUP
-- Stage: 4.3 - Customer Tenure Analysis
-- Purpose: Compare churn rates by subscription duration
-- Hypothesis: H2 - Shorter tenure is associated
--             with higher customer churn
-- =====================================================

SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 36 THEN '13-36 months'
        ELSE '37-72 months'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn_analysis.telco_customers

GROUP BY tenure_group

ORDER BY MIN(tenure);


-- =====================================================
-- QUERY 12: CUSTOMER CHURN RATE BY MONTHLY CHARGE BAND
-- Stage: 4.4 - Monthly Charges Analysis
-- Purpose: Compare churn rates across price groups
-- Hypothesis: H3 - Higher monthly charges are
--             associated with higher customer churn
-- =====================================================

SELECT
    CASE
        WHEN MonthlyCharges < 40 THEN 'Low (<40)'
        WHEN MonthlyCharges <= 80 THEN 'Medium (40-80)'
        ELSE 'High (>80)'
    END AS charge_band,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn_analysis.telco_customers

GROUP BY charge_band

ORDER BY MIN(MonthlyCharges);


-- =====================================================
-- QUERY 13: CHURN BY CONTRACT TYPE AND MONTHLY CHARGES
-- Stage: 4.5 - Combined Customer Segmentation
-- Purpose: Compare monthly charge bands within
--          each contract type
-- Business question: Is higher churn associated
-- with monthly charges within the same contract type?
-- =====================================================

SELECT
    Contract AS contract_type,

    CASE
        WHEN MonthlyCharges < 40 THEN 'Low (<40)'
        WHEN MonthlyCharges <= 80 THEN 'Medium (40-80)'
        ELSE 'High (>80)'
    END AS charge_band,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn_analysis.telco_customers

GROUP BY Contract, charge_band

ORDER BY
    FIELD(
        Contract,
        'Month-to-month',
        'One year',
        'Two year'
    ),
    FIELD(
        charge_band,
        'Low (<40)',
        'Medium (40-80)',
        'High (>80)'
    );



-- =====================================================
-- QUERY 14: CHURN BY CONTRACT TYPE AND TENURE GROUP
-- Stage: 4.6 - Combined Customer Segmentation
-- Purpose: Compare churn by contract and customer tenure
-- Business question: Do month-to-month customers show
-- higher churn within the same tenure groups?
-- =====================================================

SELECT
    Contract AS contract_type,

    CASE
        WHEN tenure BETWEEN 0 AND 12
            THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 36
            THEN '13-36 months'
        ELSE '37-72 months'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_pct

FROM telco_churn_analysis.telco_customers

GROUP BY Contract, tenure_group

ORDER BY
    FIELD(
        Contract,
        'Month-to-month',
        'One year',
        'Two year'
    ),
    FIELD(
        tenure_group,
        '0-12 months',
        '13-36 months',
        '37-72 months'
    );


-- =====================================================
-- QUERY 15: TOTAL CHURN-ASSOCIATED MONTHLY BILLING
-- Stage: 4.7 - KPI 3 Financial Exposure Analysis
-- Purpose: Calculate monthly charges associated
--          with customers recorded as churned
-- Business question: What is the monthly billing
-- value associated with cancelled customers?
-- =====================================================

SELECT
    COUNT(*) AS churned_customers,

    ROUND(
        SUM(MonthlyCharges),
        2
    ) AS churn_associated_monthly_billing

FROM telco_churn_analysis.telco_customers

WHERE Churn = 'Yes';


-- =====================================================
-- QUERY 15: TOTAL CHURN-ASSOCIATED MONTHLY BILLING
-- Stage: 4.7 - KPI 3 Financial Exposure Verification
-- Purpose: Confirm monthly billing of churned customers
-- =====================================================

SELECT
    COUNT(*) AS churned_customers,

    ROUND(
        SUM(MonthlyCharges),
        2
    ) AS churn_associated_monthly_billing

FROM telco_churn_analysis.telco_customers

WHERE Churn = 'Yes';


-- =====================================================
-- QUERY 16: CHURN-ASSOCIATED BILLING BY CONTRACT TYPE
-- Stage: 4.8 - KPI 4 Financial Exposure by Segment
-- Purpose: Calculate churn-associated monthly billing
--          and billing exposure share by contract type
-- Business question: Which contract types account
-- for the greatest share of churn-associated billing?
-- =====================================================

SELECT
    Contract AS contract_type,

    COUNT(*) AS churned_customers,

    ROUND(
        SUM(MonthlyCharges),
        2
    ) AS churn_associated_monthly_billing,

    ROUND(
        100.0 * SUM(MonthlyCharges) /
        NULLIF(
            (
                SELECT SUM(MonthlyCharges)
                FROM telco_churn_analysis.telco_customers
                WHERE Churn = 'Yes'
            ),
            0
        ),
        2
    ) AS billing_exposure_share_pct

FROM telco_churn_analysis.telco_customers

WHERE Churn = 'Yes'

GROUP BY Contract

ORDER BY churn_associated_monthly_billing DESC;


-- =====================================================
-- QUERY 17: CHURN-ASSOCIATED BILLING BY TENURE GROUP
-- Stage: 4.9 - KPI 4 Financial Exposure by Tenure
-- Purpose: Calculate monthly billing exposure
--          and exposure share by customer tenure
-- Business question: Which tenure groups account
-- for the greatest share of churn-associated billing?
-- =====================================================

SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12
            THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 36
            THEN '13-36 months'
        ELSE '37-72 months'
    END AS tenure_group,

    COUNT(*) AS churned_customers,

    ROUND(
        SUM(MonthlyCharges),
        2
    ) AS churn_associated_monthly_billing,

    ROUND(
        100.0 * SUM(MonthlyCharges) /
        NULLIF(
            (
                SELECT SUM(MonthlyCharges)
                FROM telco_churn_analysis.telco_customers
                WHERE Churn = 'Yes'
            ),
            0
        ),
        2
    ) AS billing_exposure_share_pct

FROM telco_churn_analysis.telco_customers

WHERE Churn = 'Yes'

GROUP BY tenure_group

ORDER BY MIN(tenure);


-- =====================================================
-- QUERY 18: CHURN-ASSOCIATED BILLING BY CHARGE BAND
-- Stage: 4.10 - KPI 4 Financial Exposure Analysis
-- Purpose: Calculate monthly billing exposure and
--          exposure share by subscription charge band
-- Business question: Which charge bands contribute
-- the most to churn-associated monthly billing?
-- =====================================================

SELECT
    CASE
        WHEN MonthlyCharges < 40
            THEN 'Low (<40)'
        WHEN MonthlyCharges <= 80
            THEN 'Medium (40-80)'
        ELSE 'High (>80)'
    END AS charge_band,

    COUNT(*) AS churned_customers,

    ROUND(
        SUM(MonthlyCharges),
        2
    ) AS churn_associated_monthly_billing,

    ROUND(
        100.0 * SUM(MonthlyCharges) /
        NULLIF(
            (
                SELECT SUM(MonthlyCharges)
                FROM telco_churn_analysis.telco_customers
                WHERE Churn = 'Yes'
            ),
            0
        ),
        2
    ) AS billing_exposure_share_pct

FROM telco_churn_analysis.telco_customers

WHERE Churn = 'Yes'

GROUP BY charge_band

ORDER BY MIN(MonthlyCharges);


-- =====================================================
-- QUERY 19: COMBINED CHURN RISK AND BILLING EXPOSURE
-- Stage: 4.11 - Financial Risk Segmentation
-- Purpose: Identify contract and charge combinations
--          with the greatest churn-associated billing
-- Business question: Which customer segments warrant
-- priority investigation for retention initiatives?
-- =====================================================

SELECT
    Contract AS contract_type,

    CASE
        WHEN MonthlyCharges < 40 THEN 'Low (<40)'
        WHEN MonthlyCharges <= 80 THEN 'Medium (40-80)'
        ELSE 'High (>80)'
    END AS charge_band,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_pct,

    ROUND(
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN MonthlyCharges
                ELSE 0
            END
        ),
        2
    ) AS churn_associated_monthly_billing,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN MonthlyCharges
                ELSE 0
            END
        ) /
        NULLIF(
            (
                SELECT SUM(MonthlyCharges)
                FROM telco_churn_analysis.telco_customers
                WHERE Churn = 'Yes'
            ),
            0
        ),
        2
    ) AS billing_exposure_share_pct

FROM telco_churn_analysis.telco_customers

GROUP BY Contract, charge_band

ORDER BY churn_associated_monthly_billing DESC;


-- =====================================================
-- QUERY 20: HIGH-CHARGE MONTHLY CHURN BY TENURE
-- Stage: 4.12 - Priority Segment Drill-Down
-- Purpose: Identify tenure groups contributing
--          to churn and billing exposure within
--          high-charge month-to-month customers
-- Business question: Which tenure group should
-- management investigate first?
-- =====================================================

SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12
            THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 36
            THEN '13-36 months'
        ELSE '37-72 months'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_pct,

    ROUND(
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN MonthlyCharges
                ELSE 0
            END
        ),
        2
    ) AS churn_associated_monthly_billing,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN MonthlyCharges
                ELSE 0
            END
        ) /
        NULLIF(
            (
                SELECT SUM(MonthlyCharges)
                FROM telco_churn_analysis.telco_customers
                WHERE Churn = 'Yes'
            ),
            0
        ),
        2
    ) AS overall_billing_exposure_share_pct

FROM telco_churn_analysis.telco_customers

WHERE Contract = 'Month-to-month'
  AND MonthlyCharges > 80

GROUP BY tenure_group

ORDER BY MIN(tenure);


-- =====================================================
-- QUERY 21: INTERNET SERVICE CHURN IN PRIORITY SEGMENT
-- Stage: 4.13 - Customer Service Segmentation
-- Purpose: Identify internet services associated with
--          churn among first-year high-charge monthly
--          customers
-- Business question: Which internet service accounts
-- for the greatest churn and billing exposure
-- within this priority segment?
-- =====================================================

SELECT
    InternetService AS internet_service,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churned_customers,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_pct,

    ROUND(
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN MonthlyCharges
                ELSE 0
            END
        ),
        2
    ) AS churn_associated_monthly_billing

FROM telco_churn_analysis.telco_customers

WHERE Contract = 'Month-to-month'
  AND MonthlyCharges > 80
  AND tenure BETWEEN 0 AND 12

GROUP BY InternetService

ORDER BY churn_associated_monthly_billing DESC;


-- =====================================================
-- QUERY 22: NON-CHURNED CUSTOMERS IN PRIORITY SEGMENT
-- Stage: 4.14 - Retention Opportunity Assessment
-- Purpose: Calculate the number and monthly billing
--          of non-churned customers in the highest-
--          risk observed customer segment
-- Business question: How many customers could
-- potentially be targeted for proactive retention?
-- =====================================================

SELECT
    COUNT(*) AS non_churned_customers,

    ROUND(
        SUM(MonthlyCharges),
        2
    ) AS non_churned_monthly_billing,

    ROUND(
        AVG(MonthlyCharges),
        2
    ) AS average_monthly_charge

FROM telco_churn_analysis.telco_customers

WHERE Contract = 'Month-to-month'
  AND MonthlyCharges > 80
  AND tenure BETWEEN 0 AND 12
  AND Churn = 'No';






