# dbt (Data Build Tool) with Snowflake: Comprehensive Guide & Best Practices

A production-ready guide for setting up, structuring, implementing, and scheduling dbt (Data Build Tool) with Snowflake. This repository contains architectural patterns, advanced incremental strategy implementations, and orchestrating models in an enterprise environment.

---

## Table of Contents
1. [Prerequisites & Initial Setup](#prerequisites--initial-setup)
2. [Project Architecture & Directory Structure](#project-architecture--directory-structure)
3. [Snowflake Connection Configuration (`profiles.yml`)](#snowflake-connection-configuration-profilesyml)
4. [dbt Core Concepts with Snowflake Examples](#dbt-core-concepts-with-snowflake-examples)
    - [Sources & Staging](#sources--staging)
    - [Ephemeral, View, and Table Models](#ephemeral-view-and-table-models)
5. [Deep Dive: Incremental Models & Merge Strategy](#deep-dive-incremental-models--merge-strategy)
    - [How Incremental Models Work in Snowflake](#how-incremental-models-work-in-snowflake)
    - [The `merge` Incremental Strategy](#the-merge-incremental-strategy)
    - [Production Code Example: Incremental Merge](#production-code-example-incremental-merge)
6. [Testing & Documentation](#testing--documentation)
7. [Production Scheduling & Orchestration](#production-scheduling--orchestration)
    - [Option 1: Snowflake Tasks & Streams (Native)](#option-1-snowflake-tasks--streams-native)
    - [Option 2: GitHub Actions CI/CD + dbt Cloud / Airflow](#option-2-github-actions-cicd--dbt-cloud--airflow)

---

## Prerequisites & Initial Setup

Before starting, ensure you have the following installed and configured:
- **Python 3.8+**
- **dbt-core** and **dbt-snowflake** plugin
- A Snowflake Account with `SYSADMIN` (or a dedicated `DBT_ADMIN` role) permissions to create warehouses, databases, and schemas.

### 1. Installation
Install dbt and the Snowflake adapter via `pip`:
```bash
pip install dbt-core dbt-snowflake
```

### 2. Initialize dbt Project
Initialize your dbt project structure:
```bash
dbt init dbt_snowflake_analytics
```
This command prompts you for connection details and creates the project directory layout.

---

## Project Architecture & Directory Structure

Adhering to dbt best practices, organize your models into structured layers: Staging, Intermediate, and Marts.

```text
dbt_snowflake_analytics/
├── README.md
├── dbt_project.yml
├── packages.yml
├── profiles.yml
└── models/
    ├── staging/          # Raw data cleaning, casting, and renaming (Views)
    │   ├── src_ecommerce.yml
    │   ├── stg_orders.sql
    │   └── stg_users.sql
    ├── intermediate/     # Complex joins, aggregations, and business logic (Tables/Ephemeral)
    │   └── int_order_items_summary.sql
    └── marts/            # Final analytics-ready tables for BI (Tables/Incremental)
        ├── core/
        │   └── fct_orders.sql
        └── marketing/
            └── dim_customers.sql
```

---

## Snowflake Connection Configuration (`profiles.yml`)

The `profiles.yml` file handles authentication to your Snowflake data warehouse. Place this file in your `~/.dbt/` directory or locally within your project root (using the `--profiles-dir` flag).

```yaml
dbt_snowflake_analytics:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: xy12345.us-east-1      # Snowflake Account Identifier (do not include .snowflakecomputing.com)
      user: dbt_dev_user
      password: "{{ env_var('DBT_PASSWORD') }}" # Best practice: use environment variables
      role: dbt_developer_role
      database: ANALYTICS_DEV
      warehouse: dbt_dev_wh
      schema: dbt_jdoe                # Developer sandboxed schema
      threads: 4
      client_session_keep_alive: False
    
    prod:
      type: snowflake
      account: xy12345.us-east-1
      user: dbt_prod_service_account
      private_key_path: /path/to/rsa_key.p8 # Secure authentication method for Production
      private_key_passphrase: "{{ env_var('DBT_ENV_SECRET_PASSPHRASE') }}"
      role: dbt_prod_role
      database: ANALYTICS_PROD
      warehouse: dbt_prod_wh
      schema: analytics
      threads: 8
```

---

## dbt Core Concepts with Snowflake Examples

### Sources & Staging
Sources allow you to name and describe the raw data loaded into Snowflake by your ingestion pipelines (e.g., Fivetran, Stitch, Snowpipe).

#### `models/staging/src_ecommerce.yml`
```yaml
version: 2

sources:
  - name: raw_ecommerce
    database: RAW_DATA
    schema: public
    tables:
      - name: raw_orders
      - name: raw_customers
```

#### `models/staging/stg_orders.sql`
```sql
{{ config(materialized='view') }}

with source as (
    select * from {{ source('raw_ecommerce', 'raw_orders') }}
),

renamed as (
    select
        id as order_id,
        user_id as customer_id,
        order_date::date as order_date,
        status::varchar as order_status,
        amount::number(12,2) as order_amount_usd,
        _fivetran_synced as ingested_at
    from source
)

select * from renamed
```

### Ephemeral, View, and Table Models
Configure materializations globally in `dbt_project.yml` or locally inline within the model files using `{{ config(...) }}`.

- **View (`view`)**: Created as a standard Snowflake view. Good for staging layers to avoid duplicate storage costs.
- **Table (`table`)**: Drops and recreates a physical table every run. Best for fast query performance on small-to-medium datasets.
- **Ephemeral (`ephemeral`)**: Doesn't create an object in Snowflake; builds a Common Table Expression (CTE) inside downstream queries.

---

## Deep Dive: Incremental Models & Merge Strategy

### How Incremental Models Work in Snowflake
Incremental models significantly reduce warehouse runtime and compute costs by only processing *new* or *changed* rows since the last time dbt ran. 

On Snowflake, dbt natively implements the **Merge Strategy**. Instead of writing destructive `DELETE` and `INSERT` steps manually, dbt automates a unified atomic `MERGE` statement.

### The `merge` Incremental Strategy
When you choose `strategy='merge'`, dbt generates a Snowflake standard `MERGE INTO <target_table> USING <source_query> ON <unique_key>`.
- If a record's `unique_key` matches between target and source, it **updates** the target row.
- If it doesn't match, it **inserts** the new row.

### Production Code Example: Incremental Merge
Below is a robust example of a Fact table monitoring streaming order updates using the `merge` strategy.

#### `models/marts/core/fct_orders.sql`
```sql
{{
  config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge',
    cluster_by=['order_date'],
    warehouse='dbt_large_wh'
  )
}}

with orders as (
    select * from {{ ref('stg_orders') }}
),

final as (
    select
        order_id,
        customer_id,
        order_date,
        order_status,
        order_amount_usd,
        ingested_at,
        current_timestamp() as dbt_updated_at
    from orders
)

select * from final

{# Incremental logic filters out older data during standard executions #}
{% if is_incremental() %}
  
  -- This filter will only be applied on an incremental run
  -- It optimizes Snowflake performance by looking at records ingested after the latest known record
  where ingested_at > (select max(ingested_at) from {{ this }})

{% endif %}
```

#### What dbt Executes Under the Hood in Snowflake:
When executing `dbt run --select fct_orders`, dbt automatically translates the model above into:
```sql
MERGE INTO ANALYTICS_PROD.analytics.fct_orders AS DB_TARGET
USING (
    select order_id, customer_id, order_date, order_status, order_amount_usd, ingested_at, current_timestamp() as dbt_updated_at
    from ANALYTICS_PROD.analytics.stg_orders
    where ingested_at > (select max(ingested_at) from ANALYTICS_PROD.analytics.fct_orders)
) AS DB_SOURCE
ON DB_TARGET.order_id = DB_SOURCE.order_id

WHEN MATCHED THEN
UPDATE SET 
    customer_id = DB_SOURCE.customer_id,
    order_date = DB_SOURCE.order_date,
    order_status = DB_SOURCE.order_status,
    order_amount_usd = DB_SOURCE.order_amount_usd,
    ingested_at = DB_SOURCE.ingested_at,
    dbt_updated_at = DB_SOURCE.dbt_updated_at

WHEN NOT MATCHED THEN
INSERT (order_id, customer_id, order_date, order_status, order_amount_usd, ingested_at, dbt_updated_at)
VALUES (DB_SOURCE.order_id, DB_SOURCE.customer_id, DB_SOURCE.order_date, DB_SOURCE.order_status, DB_SOURCE.order_amount_usd, DB_SOURCE.ingested_at, DB_SOURCE.dbt_updated_at);
```

> **Pro-Tip (Full Refresh Override):** To force dbt to rebuild the entire incremental table from scratch, pass the `--full-refresh` flag:
> ```bash
> dbt run --select fct_orders --full-refresh
> ```

---

## Testing & Documentation

Maintain data quality by specifying tests directly within schema YAML configurations.

### `models/marts/core/schema.yml`
```yaml
version: 2

models:
  - name: fct_orders
    description: "Centrally managed facts table containing all historical and real-time converted order records."
    columns:
      - name: order_id
        description: "Primary key for the table."
        tests:
          - unique
          - not_null
      - name: order_status
        description: "Current pipeline state of the order."
        tests:
          - accepted_values:
              values: ['placed', 'shipped', 'completed', 'returned', 'cancelled']
```

Execute tests using:
```bash
dbt test
```

---

## Production Scheduling & Orchestration

To run production models automatically, choose an engineering pattern based on your environment stack.

### Option 1: Snowflake Tasks & Streams (Native)
For a pure, native Snowflake orchestration stack without external infrastructure dependencies, wrap dbt compile outputs or leverage pre-compiled procedures to trigger scheduled tasks.

```sql
-- Create a task that triggers every hour to process incremental loads
CREATE OR REPLACE TASK scheduled_dbt_transformations
  WAREHOUSE = dbt_prod_wh
  SCHEDULE = 'USING CRON 0 * * * * UTC' -- Every Hour
AS
  -- Call compiled dbt logic or external procedural logic executing dbt-core via API/CLI containers
  CALL SYSTEM$EXECUTE_DBT_PROJECT(...);
```

### Option 2: Apache Airflow (Enterprise Orchestration)
Use the `BashOperator` or `Cosmos` (by Astronomer) to orchestrate robust DAG configurations.

```python
from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'data_engineering',
    'start_date': datetime(2026, 1, 1),
    'retries': 1,
}

with DAG(
    'dbt_snowflake_production_pipeline',
    default_args=default_args,
    description='Hourly production dbt pipeline running on Snowflake',
    schedule_interval='0 * * * *', # Hourly
    catchup=False,
) as dag:

    dbt_deps = BashOperator(
        task_id='dbt_deps',
        bash_command='cd /opt/airflow/dbt && dbt deps'
    )

    dbt_run = BashOperator(
        task_id='dbt_run_incremental',
        bash_command='cd /opt/airflow/dbt && dbt run --profiles-dir . --target prod'
    )

    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command='cd /opt/airflow/dbt && dbt test --profiles-dir . --target prod'
    )

    dbt_deps >> dbt_run >> dbt_test
```

### Option 3: dbt Cloud (Managed SaaS)
1. Connect your GitHub/GitLab repository to **dbt Cloud**.
2. Set up environments matching your Snowflake credentials (`prod`).
3. Create a **Deploy Job**.
4. Configure the **Execution Schedule** via the built-in Cron interface (e.g., `0 */1 * * *` for hourly runs).
5. Specify commands:
   - `dbt deps`
   - `dbt build` (Runs models, tests, snapshots, and seeds sequentially)

---

## Useful Command Reference
* `dbt compile`: Validates syntax and outputs raw Snowflake SQL queries to the `target/` directory.
* `dbt run --retry`: Continues execution starting exclusively from failed models on the previous run.
* `dbt docs generate && dbt docs serve`: Generates a local interactive visualization webpage tracking dependencies (lineage graphs) and metadata descriptions.
