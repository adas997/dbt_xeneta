with vw_aggregated_price_between_ports as
(select * from {{ ref ('vw_aggregated_price_between_ports') }}
)
select *
  from vw_aggregated_price_between_ports
  where 1=1
  and "Origin Port Id" = '{{ var ("origin_port_id") }}'                  
  and "Destination Port Id" = '{{ var ("destination_port_id") }}' 