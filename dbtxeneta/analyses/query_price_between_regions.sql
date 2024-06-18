with vw_aggregated_price_between_regions as
(select * from {{ ref ('vw_aggregated_price_between_regions') }}
)
select *
  from vw_aggregated_price_between_regions
  where 1=1
  and "Origin Region" = '{{ var ("origin_region") }}'                  
  and "Destination Region" = '{{ var ("destination_region") }}' 