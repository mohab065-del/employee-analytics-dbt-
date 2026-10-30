# Employee Analytics dbt Project

This dbt project transforms employee data from an ODS source into staging models and a dimensional data warehouse. It uses dbt Core with the SQL Server adapter.

## Data flow

```text
SQL Server: depi.dbo.ODS
        |
        +--> Staging: DIMemployee, DIMcountry, DIMdepartment,
        |              DIMgender, DIMdate, OBT
        |
        +--> DWH: fact_employee
```

### Staging

Models are materialized in the `stg` schema:

- `DIMemployee`: one record per employee, with a cleaned full name.
- `DIMcountry`, `DIMdepartment`, `DIMgender`: distinct descriptive values with generated integer IDs.
- `DIMdate`: distinct dates of birth with date key, year, month, day, and name attributes.
- `OBT`: employee-level staging data combining descriptive attributes and salary.

### DWH

`fact_employee` is materialized in the `dwh` schema. It joins the staged employee data to the country, department, gender, and date dimensions and stores the corresponding keys and salary.

## Requirements

- Python and dbt Core
- The dbt SQL Server adapter (`dbt-sqlserver`)
- SQL Server access to the configured database and the `dbo.ODS` source table
- A dbt profile named `DBT_PROJECT`, configured for the `DBT_PROJECT` project

Do not commit database credentials. Configure them in your local dbt profile or your deployment environment.

## Run the project

From the project directory:

```bash
dbt debug
dbt run
dbt test
```

To run an individual model or its tests:

```bash
dbt run --select fact_employee
dbt test --select fact_employee
```

## Tests and macros

Generic tests in the staging and DWH schema files validate required values, uniqueness, accepted gender values, and fact-to-dimension relationships. The singular test `tests/negative_salary.sql` fails if `OBT` contains a negative salary.

Custom macros in `macros/`:

- `capitalize_name`: trims and formats first and last names.
- `generate_schema_name`: uses the configured custom schema name, or the target schema when none is provided.

## Documentation

Model, column, and source descriptions are maintained alongside the models in `models/staging/schema.yml`, `models/dwh/schema.yml`, and `models/staging/source.yml`.

Generate and preview the dbt documentation site locally:

```bash
dbt docs generate
dbt docs serve
```

The local preview is not a public URL. To share the documentation, publish the generated `target/` documentation files to a hosting service such as GitHub Pages, then add the public URL here.

## Project layout

```text
models/
  staging/   # ODS source definitions and staging models
  dwh/       # Dimensional warehouse models
macros/      # Reusable SQL/Jinja macros
tests/       # Singular data tests
seeds/       # Project seed data
```
