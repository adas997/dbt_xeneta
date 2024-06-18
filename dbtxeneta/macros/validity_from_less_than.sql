{% test validity_from_less_than(model, column_name) %}

select *
 from {{ model }}
 where {{ column_name }} < '{{ var ("start_date") }}'

{% endtest %} 