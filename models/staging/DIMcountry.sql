WITH ods_country AS (
    SELECT DISTINCT country
    FROM {{source("source_ods","ODS")}}
    WHERE country IS NOT NULL
)
SELECT
    ROW_NUMBER() OVER (ORDER BY country) AS country_id,
    country
FROM ods_country