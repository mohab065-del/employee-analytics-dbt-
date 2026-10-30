with dates as (
    SELECT DISTINCT
        CAST(DOB AS DATE) AS birth_date
    FROM {{ source("source_ods", "ODS") }}
    WHERE DOB IS NOT NULL
)
SELECT
    CONVERT(INT, CONVERT(CHAR(8), birth_date, 112)) AS date_key,
    birth_date AS [date],
    YEAR(birth_date) AS year,
    MONTH(birth_date) AS month,
    DAY(birth_date) AS day,
    DATENAME(MONTH, birth_date) AS month_name,
    DATENAME(WEEKDAY, birth_date) AS day_name
    from dates
