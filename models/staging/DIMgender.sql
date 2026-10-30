WITH genders AS (
    SELECT DISTINCT gender
    FROM {{source("source_ods","ODS")}}
    WHERE gender IS NOT NULL
)
SELECT
    ROW_NUMBER() OVER (ORDER BY gender) AS gender_id,
    gender
FROM genders
