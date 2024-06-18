WITH PORTS AS (
    SELECT
        *
    FROM
        {{ ref ('stg_ports') }}
),
price as (
    SELECT
    D_ID,
    ORIGIN_PID,
    DESTINATION_PID,
    VALID_FROM,
    VALID_TO,
    COMPANY_ID,
    SUPPLIER_ID,
    EQUIPMENT_ID,
    VALID_DATE,
    PRICE_IN_USD,
    --CNT_BY_COMPANY,
    --CNT_BY_SUPPLIER,
    CASE
        WHEN CNT_BY_COMPANY >= {{ var('num_companies') }}
        AND CNT_BY_SUPPLIER >= {{ var('num_suppliers') }} THEN 'TRUE'
        ELSE 'FALSE'
    END AS DQ_OK
FROM
    (
        SELECT
            *,
            COUNT(DISTINCT COMPANY_ID) OVER (
                PARTITION BY ORIGIN_PID,
                DESTINATION_PID,
                EQUIPMENT_ID
            ) CNT_BY_COMPANY,
            COUNT(DISTINCT SUPPLIER_ID) OVER (
                PARTITION BY ORIGIN_PID,
                DESTINATION_PID,
                EQUIPMENT_ID
            ) CNT_BY_SUPPLIER,
        FROM
            {{ ref ('stg_price_usd') }} 
    )
WHERE
    1 = 1
    AND DQ_OK = 'TRUE'
),
FINAL as (
    select
        DISTINCT p.PORT_ID,
        p.REGION_ID,
        p.COUNTRY_CODE,
        S.ORIGIN_PID,
        S.DESTINATION_PID,
        S.COMPANY_ID,
        S.SUPPLIER_ID,
        S.EQUIPMENT_ID,
        ROUND(avg(S.PRICE_IN_USD),4) AVG_PRICE_IN_USD,
        ROUND({{ median('S.PRICE_IN_USD') }},4) as MEDIAN_PRICE_IN_USD,
        S.DQ_OK
    FROM
        price s
        left join ports p on (
            (p.PORT_ID = s.ORIGIN_PID)
            OR (p.PORT_ID = s.DESTINATION_PID)
        )
        --where S.ORIGIN_PID = 898
    group by
        p.PORT_ID,
        p.REGION_ID,
        p.COUNTRY_CODE,
        S.ORIGIN_PID,
        S.DESTINATION_PID,
        S.COMPANY_ID,
        S.SUPPLIER_ID,
        S.EQUIPMENT_ID,
        S.DQ_OK
)
SELECT
    {{ dbt_utils.generate_surrogate_key(['PORT_ID', 'REGION_ID','COUNTRY_CODE','ORIGIN_PID','DESTINATION_PID','COMPANY_ID','SUPPLIER_ID','EQUIPMENT_ID']) }} as hash_agg_price_id,
     *
FROM
    FINAL