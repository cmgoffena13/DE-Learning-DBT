{{
    config(materialized='incremental', on_schema_change='fail')
}}
WITH src_reviews AS (
    SELECT * FROM {{ ref('src_reviews') }}
)
SELECT 
{{ dbt_utils.surrogate_key(['listing_id', 'review_date', 'reviewer_name', 'review_text']) }} AS review_id,
* 
FROM src_reviews
WHERE review_text IS NOT NULL

{% if is_incremental() %}
  {% if var("start_date", False) and var("end_date", False) %}
  {{ log('Loading ' ~ this ~ ' incrementally (start date: ' ~ var("start_date") ~ ', end_date: ' ~ var("end_date") ~ ')') }}
    AND review_date >= '{{ var("start_date") }}'
    AND review_date < '{{ var("end_date") }}'
  {% else %}
    AND review_date > (SELECT MAX(review_date) FROM {{ this }})
  {{ log('Loading ' ~ this ~ ' incrementally (all missing dates)', info=True) }}
  {% endif %}
{% endif %}