{{
    config (
        materialized = 'view',schema = 'final'
    )
}}
SELECT
    F.COUNTRY_CODE "Country Code",
    F.ORIGIN_PID as "Origin Port Id",
    F.DESTINATION_PID as "Destination Port Id",
    F.COMPANY_ID as "Company Id",
    F.SUPPLIER_ID as "Supplier Id",
    F.EQUIPMENT_ID as "Equipment Id",
    F.AVG_PRICE_IN_USD as "Average Price in USD",
    F.MEDIAN_PRICE_IN_USD as "Median Price in USD" ,
    R_ORIGIN.REGION_NAME AS "Origin Region",
    R_DESTINATION.REGION_NAME AS "Destination Region",
    F.DQ_OK as "Data Quality"
FROM
    {{ ref ('fct_aggregated_price') }} F
    INNER JOIN {{ ref ('stg_ports') }} P_ORIGIN ON (F.ORIGIN_PID = P_ORIGIN.PORT_ID)
    INNER JOIN {{ ref ('stg_ports') }} P_DESTINATION ON (F.DESTINATION_PID = P_DESTINATION.PORT_ID)
    INNER JOIN {{ ref ('stg_regions') }} R_ORIGIN ON (P_ORIGIN.REGION_ID = R_ORIGIN.REGION_ID)
    INNER JOIN {{ ref ('stg_regions') }} R_DESTINATION ON (
        P_DESTINATION.REGION_ID = R_DESTINATION.REGION_ID
    )