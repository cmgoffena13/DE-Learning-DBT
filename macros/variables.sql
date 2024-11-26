{% macro learn_variables() %}
    # jinja variable
    {% set your_name_jinja = "Cort" %}
    {{ log("Hello " ~ your_name_jinja, info=True) }}

    # dbt variable
    {{ log("Hello dbt user " ~ var("user_name", "NO USERNAME IS SET!!") ~ "!", info=True) }}
{% endmacro %}