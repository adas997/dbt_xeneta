{{
    config (
        materialized = 'table',schema = 'staging'
    )
}}

with datapoints as (
        select
            *
        from
            {{ ref ('datapoints_1') }}
        where
            1=1
           -- and valid_from >= '2021-01-01'
           -- and valid_to <= '2022-06-01'
        union all
        select
            *
        from
            {{ ref ('datapoints_2') }}
        where
            1=1   
    ),
    charges as (
        select
            d_id,
            currency,
            sum(charge_value) as charge_value
        from
            {{ ref ('charges_1') }}
        group by
            d_id,
            currency
        union all
        select
            d_id,
            currency,
            sum(charge_value) as charge_value
        from
            {{ ref ('charges_2') }}
        group by
            d_id,
            currency

    ),
    data as (
        select
            d.*,
            c.currency,
            c.charge_value
        from
            datapoints d
            left join charges c on (d.d_id = c.d_id)
    )
select
    d_id,
    origin_pid,
    destination_pid,
    valid_from,
    valid_to,
    company_id,
    supplier_id,
    equipment_id,
    valid_date,
    sum(price_in_usd) as price_in_usd
from(
        select
            d.*,
            r.*,
            --iif(d.currency = 'USD', d.charge_value, d.charge_value/r.exchange_rate ) as price
            case
                when d.currency = 'USD' then d.charge_value
                else d.charge_value / r.exchange_rate
            end as price_in_USD
        from
            data d
            left join {{  ref('stg_rates')  }} r 
            on (
                r.currency = d.currency
                and r.valid_date between d.valid_from
                and d.valid_to
            )
       -- where
           -- d.d_id = 373356955
        --order by
            --r.valid_date
    )
group by
    d_id,
    origin_pid,
    destination_pid,
    valid_from,
    valid_to,
    company_id,
    supplier_id,
    equipment_id,
    valid_date
order by d_id,valid_date  	