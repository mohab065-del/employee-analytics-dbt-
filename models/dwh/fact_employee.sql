WITH employee_data AS (
    SELECT
        employee_id,
        department,
        gender,
        country,
        [date],
        salary
    FROM {{ ref('OBT') }}
)
SELECT
    e.employee_id,
    country.country_id,
    department.department_id,
    gender.gender_id,
    date_dim.date_key,
    e.salary
FROM employee_data AS e
LEFT JOIN {{ ref('DIMcountry') }} AS country
    ON e.country = country.country
LEFT JOIN {{ ref('DIMdepartment') }} AS department
    ON e.department = department.department
LEFT JOIN {{ ref('DIMgender') }} AS gender
    ON e.gender = gender.gender
LEFT JOIN {{ ref('DIMdate') }} AS date_dim
    ON CAST(e.[date] AS DATE) = date_dim.[date]