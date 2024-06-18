  select count(DISTINCT COMPANY_ID) cnt_company_id,
    ORIGIN_PID,
    DESTINATION_PID,
    EQUIPMENT_ID
    from {{ ref ('fct_aggregated_price') }}
    group by ORIGIN_PID,
    DESTINATION_PID,
    EQUIPMENT_ID
    having count(DISTINCT COMPANY_ID) < {{ var('num_companies') }}
    union all
    select count(DISTINCT SUPPLIER_ID) cnt_company_id,
    ORIGIN_PID,
    DESTINATION_PID,
    EQUIPMENT_ID
    from {{ ref ('fct_aggregated_price') }}
    group by ORIGIN_PID,
    DESTINATION_PID,
    EQUIPMENT_ID
    having count(DISTINCT SUPPLIER_ID) < {{ var('num_suppliers') }}
