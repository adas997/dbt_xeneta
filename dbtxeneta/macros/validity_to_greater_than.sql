{% test validity_to_greater_than(model, column_name) %}

select *
 from {{ model }}
 where {{ column_name }} > '{{ var ("end_date") }}'

{% endtest %} 