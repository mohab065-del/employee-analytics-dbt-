{{config(
    materialized='incremental',
    unique_key='employee_id'
)}}
WITH employees AS (
    SELECT DISTINCT
        ID AS employee_id,
        first_name,
        last_name,
        email
    FROM {{ source("source_ods", "ODS") }}
    WHERE ID IS NOT NULL
)
SELECT
    employee_id,
    {{capitalize_name('first_name','last_name')}} AS full_name,
    first_name,
    last_name,
    email
FROM employees
{% if is_incremental() %}
    WHERE employee_id NOT IN (SELECT employee_id FROM {{ this }})
{% endif %}