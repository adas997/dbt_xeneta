WITH RAW_RATES
AS
(
 SELECT *
FROM {{ source ('dbtxeneta','rates')  }} 
),
FINAL AS (
SELECT 
DAY  AS VALID_DATE, 
CURRENCY AS CURRENCY, 
RATE AS EXCHANGE_RATE
FROM RAW_RATES
)
SELECT * 
FROM FINAL