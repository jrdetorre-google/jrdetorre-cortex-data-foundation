# Cortex Data Foundation

The Cortex Data Foundation is the core architectural component of
[Google Cloud Cortex Framework](https://cloud.google.com/solutions/cortex).
Cortex Framework provides reference architectures, deployable solutions, and
packaged implementation services to kickstart your Data and AI Cloud journey.
Cortex Framework incorporates your source data into tools and services that help ingest,
transform, and load it to get insights faster from pre-defined data models that can be automatically
deployed for use with [Google Cloud BigQuery](https://cloud.google.com/bigquery)

This repository contains the Entity Relationship (ERD) diagrams, scripts and files
to deploy the Cortex Framework. For more information and instructions, see our
official [Cortex Framework documentation site](https://cloud.google.com/cortex/docs).

# Data sources and workloads

Cortex Framework focuses on solving specific problems and offers pre built solutions
for business areas like Marketing, Sales, Supply Chain, Manufacturing, Finance, and Sustainability.
Cortex Framework is flexible and it can include data from sources beyond what is prebuilt.

This is a modified version only running the CDC layer of SAP workloads

*   [SAP (ECC and S/4)](https://cloud.google.com/cortex/docs/operational-sap)

**Note**: If you want to know more about which entities are covered in each data source, see the
Entity-Relationship Diagrams (ERD) in the [docs](https://github.com/GoogleCloudPlatform/cortex-data-foundation/tree/main/docs) folder.

# Deployment

For this specific Cortex Framework deployment instructions, see the following:

* **Prerequisites** 
After reading the [prerequisites](https://cloud.google.com/cortex/docs/deployment-prerequisites) for Cortex Data Foundation deployment, create a RAW and a CDC dataset in BigQuery in a selected region following the instructions declared here [Establish workloads](https://cloud.google.com/cortex/docs/deployment-step-one)

In the same region, create a bucket for the DAG python code and CDC SQL script artifacts generated and another bucket for the logs.

* **Clone repository** 

Clone and pull the repo
```
git clone https://github.com/jrdetorre-google/jrdetorre-cortex-data-foundation.git
cd jrdetorre-cortex-data-foundation
git pull
```
* **Adjust config.json** 

Apply the required values to the config file in [config/config.json](https://github.com/jrdetorre-google/jrdetorre-cortex-data-foundation/blob/main/config/config.json) as it's described in [Cortex Framework: integration with SAP](https://cloud.google.com/cortex/docs/operational-sap).

* **Configure Table CDC** 

Raw tables must be availabe in the raw BigQuery dataset before the deployment. DD03L table must be trasferred if you are willing to replicate custom or z tables, so that the CDC generator can check the table schemas to create the CDC scripts. There are some prerequisites for SAP replication declared here: [Prerequisites for SAP replication](https://cloud.google.com/cortex/docs/operational-sap#prerequisites_for_sap_replication_2)

The Change Data Capture processing method used here is **Append-always**.

In order to define the tables to CDC process you must edit the [src/SAP/SAP_CDC/cdc_settings.yaml](https://github.com/jrdetorre-google/jrdetorre-cortex-data-foundation/blob/main/src/SAP/SAP_CDC/cdc_settings.yaml) file including the tables to replicate and the replication frecuency according to the [scheduling options supported by Apache Airflow](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dag-run.html).

```
data_to_replicate:
- base_table: adrc
    load_frequency: "@hourly"
- base_table: adr6
    target_table: adr6_cdc
    load_frequency: "@daily"
- base_table: zztable_customer
    load_frequency: "@daily"
- base_table: zzspecial_table
    load_frequency: "RUNTIME"
- base_table: vbap
    load_frequency: "@daily"
    partition_details: {
    column: "erdat", partition_type: "time", time_grain: "day" }
```

**Optional:** If you want to add and process tables individually after deployment, you can modify the [cdc_settings.yaml](https://github.com/jrdetorre-google/jrdetorre-cortex-data-foundation/blob/main/src/SAP/SAP_CDC/cdc_settings.yaml) file to process only the tables you need and re-execute the specified module calling [src/SAP_CDC/cloudbuild.cdc.yaml](https://github.com/jrdetorre-google/jrdetorre-cortex-data-foundation/blob/main/src/SAP/SAP_CDC/cloudbuild.cdc.yaml) directly.

dd

    2. [Clone repository](https://cloud.google.com/cortex/docs/deployment-step-two)
    3. [Determine integration mechanism](https://cloud.google.com/cortex/docs/deployment-step-three)
    4. [Set up components](https://cloud.google.com/cortex/docs/deployment-step-four)
    5. [Configure deployment](https://cloud.google.com/cortex/docs/deployment-step-five)
    6. [Execute deployment](https://cloud.google.com/cortex/docs/deployment-step-six)

## Optional steps

You can customize your Cortex Framework deployment with the following optional steps:

*   [Use different projects to segregate access](https://cloud.google.com//cortex/docs/optional-step-segregate-access)
*   [Use Cloud Build features](https://cloud.google.com//cortex/docs/optional-step-cloud-build-features)
*   [Configure external datasets for K9](https://cloud.google.com//cortex/docs/optional-step-external-datasets)
*   [Enable Turbo Mode](https://cloud.google.com/cortex/docs/optional-step-turbo-mode)
*   [Telemetry](https://cloud.google.com/cortex/docs/optional-step-telemetry)

