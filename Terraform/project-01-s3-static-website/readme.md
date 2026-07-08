# S3 Static Website — Terraform example

## Overview

This project demonstrates how to provision an AWS S3 bucket configured to serve a static website using Terraform. It includes the Terraform configuration to create the S3 bucket, configure the bucket policy for public read access (where appropriate), and optionally deploy site content from the `build/` directory.

Use this repository as a learning example or a starting point for simple static site hosting on AWS.

## Repository structure

- `provider.tf` — AWS provider configuration (region, provider settings).
- `s3.tf` — S3 bucket resource and related configuration (website settings, policies, optionally lifecycle rules).
- `outputs.tf` — Exposes useful outputs such as the site endpoint and bucket name.
- `build/` — Local site build output (example `index.html`, `error.html`) that you can upload to the S3 bucket.

## Prerequisites

- Terraform 1.0+ installed and available on your PATH.
- An AWS account and credentials configured locally (via environment variables, `~/.aws/credentials`, or an assumed role).
- Optional: AWS CLI for manual uploads or verification.

## Quickstart — deploy the static site

1. Initialize Terraform to install providers and set up the working directory:

```bash
terraform init
```

2. Review the planned changes:

```bash
terraform plan -out plan.tfplan
```

3. Apply the plan to create resources:

```bash
terraform apply "plan.tfplan"
```

4. After apply completes, Terraform will output the S3 website endpoint (if configured) and the bucket name. Use the endpoint to verify the site.

## Uploading site files

This project includes a `build/` directory with example files. To upload them to the bucket created by Terraform manually, you can use the AWS CLI:

```bash
aws s3 sync build/ s3://$(terraform output -raw bucket_name)
```

Alternatively, add a Terraform null_resource/provisioner or CI/CD step to automate deployments.

## Configuration and variables

Check `s3.tf` and `provider.tf` for configurable values. Common variables to expose and adjust:

- `bucket_name` — S3 bucket name (make sure it is globally unique if you set it explicitly).
- `region` — AWS region where the bucket will be created.
- `website_index` / `website_error` — Index and error documents for S3 website hosting.

If this project doesn't include a `variables.tf`, you can set values by editing `s3.tf` or by using `-var`/`terraform.tfvars`.

## Security notes

- Serving content from S3 as a public website requires a public bucket or CloudFront in front of a private bucket. For production, consider using CloudFront with Origin Access Control (OAC) to keep the S3 bucket private.
- Be careful with bucket policies that allow wide public access — review AWS best practices and your security requirements.

## Cleaning up

To destroy the resources created by this project:

```bash
terraform destroy
```

Confirm the resources to be destroyed and accept the prompt.

## Optional improvements

- Add CloudFront distribution for HTTPS, caching, and global delivery.
- Add a deployment pipeline (GitHub Actions / GitLab CI / CodePipeline) to automatically build and push files on commit.
- Use `aws_s3_bucket_replication_configuration` for cross-region replication if needed.

## Troubleshooting

- If Terraform cannot create the bucket due to name collision, choose a unique `bucket_name`.
- If site content doesn't appear, ensure the files are uploaded and the correct index document is set in the bucket website configuration.

## References

- AWS S3 Static Website Hosting: https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html
- Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest

---

If you'd like, I can: (a) add a `variables.tf` with sensible defaults, (b) add a simple CloudFront distribution, or (c) create a GitHub Actions workflow to automate uploads. Which would you like next?
