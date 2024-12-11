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

For Cortex Framework deployment instructions, see the following:

*   **Quickstart Demo**: a [quickstart demo](https://cloud.google.com/cortex/docs/quickstart-demo) to
test the Cortex Framework set up process with sample data within just a few clicks. *This demo deployment
is not suitable for production environments*.
*   **Deployment steps**: after reading the [prerequisites](https://cloud.google.com/cortex/docs/deployment-prerequisites) for Cortex Data Foundation deployment, follow the steps for deployment in production environments:
    1. [Establish workloads](https://cloud.google.com/cortex/docs/deployment-step-one)
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

