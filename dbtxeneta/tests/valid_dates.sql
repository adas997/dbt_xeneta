select * from 
{{ ref ('stg_price_usd') }}
--where valid_date not between '2021-01-01' and '2022-06-01'
where valid_date not between '{{ var ("start_date") }}' and '{{ var ("end_date") }}'