WITH departments AS (
    SELECT DISTINCT department
    FROM {{source("source_ods","ODS")}} 
    WHERE department IS NOT NULL
)
SELECT
    ROW_NUMBER() OVER (ORDER BY department) AS department_id,
    department
FROM departments