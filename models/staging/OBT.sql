{{config(
    materialized='incremental',
    unique_key='employee_id'
)}}
SELECT DISTINCT
    ID AS employee_id,
    first_name,
    last_name,
    {{capitalize_name('first_name','last_name')}} AS full_name,
    email,
    gender,
    country,
    department,
    CAST(REPLACE(CAST(salary AS VARCHAR(MAX)), '$', '') AS DECIMAL(10,2)) AS salary,
    DOB AS [date]
FROM {{ source("source_ods", "ODS") }}
WHERE ID IS NOT NULL
{% if is_incremental() %}
    AND ID NOT IN (SELECT employee_id FROM {{ this }})
{% endif %}