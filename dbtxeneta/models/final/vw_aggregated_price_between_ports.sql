{{
    config (
        materialized = 'view',schema = 'final'
    )
}}

WITH DATA AS (
        SELECT
            F.*,
            R.REGION_NAME,
            R.PARENT_REGION,
            P_ORIGIN.PORT_CODE AS ORIGIN_PORT_ID,
            P_ORIGIN.PORT_NAME AS ORIGIN_PORT_NAME,
            P_DESTINATION.PORT_CODE AS DESTINATION_PORT_ID,
            P_DESTINATION.PORT_NAME AS DESTINATION_PORT_NAME
        FROM
            {{ ref ('fct_aggregated_price') }}  F
            LEFT JOIN {{ ref ('stg_regions') }}  R ON (R.REGION_ID = F.REGION_ID)
            LEFT JOIN {{ ref ('stg_ports') }} P_ORIGIN ON (F.ORIGIN_PID = P_ORIGIN.PORT_ID)
            LEFT JOIN {{ ref ('stg_ports') }} P_DESTINATION ON (F.DESTINATION_PID = P_DESTINATION.PORT_ID)
    ),
    FINAL AS (
        SELECT
            PORT_ID AS "Port Id",
            REGION_ID AS "Region Id",
            REGION_NAME AS "Region",
            PARENT_REGION AS "Parent Region",
            COUNTRY_CODE AS "Country Code",
            COMPANY_ID AS "Company",
            SUPPLIER_ID AS "Supplier",
            EQUIPMENT_ID AS "Equipment",
            AVG_PRICE_IN_USD AS "Avg. Price in Dollar",
            MEDIAN_PRICE_IN_USD AS "Median. Price in Dollar",
            ORIGIN_PORT_ID AS "Origin Port Id",
            ORIGIN_PORT_NAME AS "Origin Port",
            DESTINATION_PORT_ID AS "Destination Port Id",
            DESTINATION_PORT_NAME AS "Destination Port",
            DQ_OK AS "Data Quality"
        FROM
            DATA
        WHERE
            1=1
            --AND ORIGIN_PORT_ID = '{{ var ("origin_port_id") }}'                  
            --AND DESTINATION_PORT_ID = '{{ var ("destination_port_id") }}'    
    )
SELECT
    *
FROM
    FINAL