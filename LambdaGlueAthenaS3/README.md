# Enterprise Data Quality and Analytics Pipeline Using AWS Step Functions

## Overview

This repository contains a reference implementation and documentation for an enterprise-grade data ingestion, validation, transformation, and reporting pipeline orchestrated by AWS Step Functions. It models a retail scenario where transactional CSV files are uploaded to S3 by hundreds of stores throughout the day.

## What is included

- A Step Functions state machine definition: [state_machine/state_machine.asl.json](state_machine/state_machine.asl.json)
- Lambda function stubs and helpers: [`lambdas/`](lambdas/)
- A sample AWS Glue PySpark ETL job: [`glue/glue_job.py`](glue/glue_job.py)
- `requirements.txt` listing Python dependencies for local packaging

## Design highlights

- Input validation (existence, naming, extension, metadata) with early fail and SNS notification
- Parallel validations: virus scan, schema validation, duplicate detection, business-rule checks
- Archival of original uploads
- Synchronous Glue job invocation (`.sync`) so the state machine waits for ETL completion
- Post-ETL verification of expected outputs and metrics
- Athena query submission with polling loop (Wait + Check) to handle asynchronous execution
- Map state to process Athena query results in parallel per-record
- Parallel generation of business outputs (JSON, CSV, PDF) and storage in reporting S3
- Comprehensive Retry and Catch patterns, with SNS notifications for failures

## Usage

1. Review and replace ARN placeholders in `state_machine/state_machine.asl.json` with your account-specific ARNs.
2. Package Lambda functions (the `lambdas/` folder) and deploy them with your preferred deployment tool (SAM, Serverless, CDK, or manual ZIP upload). Install dependencies from `requirements.txt`.
3. Create the AWS Glue job named `retail-etl-job` and supply the `glue/glue_job.py` script.
4. Deploy Step Functions state machine using AWS Console, CLI, SAM, or CloudFormation using the provided ASL.

## Further documentation

The state machine is heavily commented and designed to demonstrate many Amazon States Language (ASL) features. See the `state_machine/state_machine.asl.json` file for the full state-by-state behavior and the `lambdas/` folder for concrete Lambda handler examples and usage notes.

## License

This repository is a sample for educational and prototyping purposes.
