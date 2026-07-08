# Project-00: Terraform concepts and tutorials

This folder contains a sequence of small Terraform examples and tutorials, each in its own numbered subfolder. The purpose is to teach key Terraform concepts incrementally. The sections below give a self-contained explanation for each subfolder, list the important files, and provide quick usage notes and tips.

## 01 - benefits-iac

Concept: Why use Infrastructure as Code (IaC)

- Explains IaC benefits: repeatability, versioning, reviewable changes, automation, and drift detection.
  Key files: `vpc.tf`
  Notes:
- `vpc.tf` demonstrates a minimal VPC, subnets, Internet Gateway, and route table. Use this folder to practice `terraform init`, `plan`, and `apply` for simple resource creation.

## 02 - hcl

Concept: HashiCorp Configuration Language (HCL)

- Introduces HCL syntax: blocks, attributes, expressions, interpolation, and comments.
  Key files: `hcl.tf`
  Notes:
- Use this folder to learn HCL structure and how Terraform declares resources and values.

## 03 - first-tf-project

Concept: Minimal Terraform project layout and first deployment

- Shows provider configuration and a simple S3 example.
  Key files: `providers.tf`, `s3.tf`
  Notes:
- Practice `terraform init`, then `terraform plan` and `terraform apply`. Observe the state file and how resources map to the config.

## 04 - backends

Concept: Remote state backends

- Demonstrates configuring state storage backends (S3 backend files `dev.s3.tfbackend`, `prod.s3.tfbackend`) and how to switch backends.
  Key files: `s3.tf`, `dev.s3.tfbackend`, `prod.s3.tfbackend`, `providers.tf`
  Notes:
- Use `terraform init -backend-config=dev.s3.tfbackend` to initialize with a specific backend. Remote backends are essential for collaboration and state locking.

## 05 - providers

Concept: Provider configuration and version constraints

- Shows declaring provider blocks and `required_providers` constraints.
  Key files: `providers.tf`
  Notes:
- Learn how to pin provider versions and configure multiple providers if needed.

## 06 - resources

Concept: Resource blocks and lifecycle

- Illustrates creating multiple resource types (compute, networking) and demonstrates resource arguments and lifecycle behaviors.
  Key files: `compute.tf`, `networking.tf`, `provider.tf`, `README.md`
  Notes:
- Inspect `compute.tf` and `networking.tf` to see common resource attributes. Use `terraform show` to examine created resources.

## 07 - data-sources

Concept: Data sources vs resources

- Data sources read existing information from the provider without creating it (e.g., AMI lookup, availability zones).
  Key files: `compute.tf`, `provider.tf`
  Notes:
- Use data sources to make modules/configs dynamic and provider-aware without hardcoding values.

## 08 - input-vars-locals-outputs

Concept: Variables, locals, and outputs

- Shows how to parameterize modules with `variables.tf`, override values with `terraform.tfvars` and `override.tfvars`, compute derived values with `locals`, and expose useful outputs.
  Key files: `variables.tf`, `terraform.tfvars`, `override.tfvars`, `shared-locals.tf`, `s3.tf`, `outputs.tf`, `compute.tf`, `provider.tf`
  Notes:
- Practice passing values via CLI `-var 'name=value'`, using `terraform.tfvars`, and reading outputs with `terraform output`.

## 09 - expressions

Concept: Expressions, operators, for-expressions, maps, lists, and splat

- Demonstrates list/map operations, `for` and `for_each` constructs, splat expressions, and common operators.
  Key files: `for-lists.tf`, `for-maps.tf`, `lists-maps.tf`, `operators.tf`, `splat.tf`, `variables.tf`, `terraform.tfvars`, `provider.tf`
  Notes:
- Use this folder to learn advanced expressions that make configurations concise and data-driven.

## 10 - functions

Concept: Built-in functions

- Shows usage of Terraform functions (e.g., `lookup`, `join`, `format`, `file`, `jsondecode`) to transform data.
  Key files: `functions-examples.tf`, `provider.tf`, `users.yaml`
  Notes:
- Many functions are available; consult the Terraform docs. `file()` reads local files (used here for `users.yaml`).

## 11 - multiple-resources

Concept: Creating multiple similar resources and separating concerns

- Demonstrates modular resource layouts, variables for counts, and using `for_each` to create multiple resources.
  Key files: `compute.tf`, `networking.tf`, `data.tf`, `variables.tf`, `terraform.tfvars`, `provider.tf`
  Notes:
- Use `count` and `for_each` to scale resources and avoid copy/paste.

## 12 - public-modules

Concept: Consuming public modules from the registry

- Shows how to use published modules (or shared code) to avoid reinventing common infrastructure patterns.
  Key files: `compute.tf`, `networking.tf`, `shared-data.tf`, `provider.tf`
  Notes:
- Reference modules via `module "name" { source = "registry..." }` and pass variables.

## 13 - local-modules

Concept: Authoring and using local modules

- Demonstrates module structure under `modules/` with inputs/outputs and how to call them from the root.
  Key files: `compute.tf`, `networking.tf`, `providers.tf`, `outputs.tf`, `modules/networking/*`
  Notes:
- Local modules keep code DRY and maintainable. Study `modules/networking/README.md` for internal module docs.

## 14 - use-own-module

Concept: Re-using a locally-developed module in a different project

- Shows how to structure your module for reuse and reference it in other root modules.
  Key files: `providers.tf`, `networking.tf`
  Notes:
- When publishing modules, include a `README` and `examples/`.

## 15 - object-validation

Concept: Input object validation and type constraints

- Illustrates how to use `type` and `validation` blocks for complex variable types (objects, maps) to catch errors early.
  Key files: `variables.tf`, `networking.tf`, `compute.tf`, `provider.tf`
  Notes:
- Use descriptive `validation` messages to improve developer UX.

## 16 - state-manipulation

Concept: Advanced state operations (import, taint, move, remove)

- Shows `terraform import` usage, `terraform state mv`, `terraform state rm`, and how to taint/untaint resources.
  Key files: `import.tf`, `move-state.tf`, `remove.tf`, `taint.tf`, `provider.tf`, modules under `modules/`
  Notes:
- These commands change the state file or resource association—practice in a non-production environment and back up state first.

## 17 - workspaces

Concept: Terraform CLI workspaces for environment separation

- Demonstrates using separate workspaces (`dev`, `int`, `prod`, `staging`) with different variable files (`*.tfvars`) to manage multiple environments in the same configuration.
  Key files: `provider.tf`, `s3.tf`, `variables.tf`, `dev.tfvars`, `int.tfvars`, `prod.tfvars`, `staging.tfvars`
  Notes:
- Use `terraform workspace new dev` and `terraform workspace select prod`. Workspaces are lightweight; for major differences consider separate state/backends or directories.

## 18 - terraform-cloud

Concept: Using Terraform Cloud and remote execution

- Shows provider/configuration examples for integrating with Terraform Cloud (remote runs, variables, state management) and examples that combine resources like S3 and compute.
  Key files: `provider.tf`, `s3.tf`, `compute.tf`, `random.tf`, `variables.tf`
  Notes:
- Configure backend with `terraform login` and workspace settings in Terraform Cloud. Remote runs centralize state and provide run history and locking.

## How to use these notes

- Start at `01-benefits-iac` for conceptual grounding, then follow numerically to build practical skills.
- Typical commands for each folder:

```bash
cd project-00-tutorial/NN-folder
terraform init
terraform plan
terraform apply
terraform destroy
```

- Replace `NN-folder` with the folder number/name.
- For workspace/backends/state operations, read the folder notes before running commands—these actions can affect remote state.

If you want, I can also:

- Add individual `README.md` files in each subfolder that point to relevant code snippets.
- Generate diagrams or Mermaid charts for network/topology examples (VPC/subnets).
- Create an index `SUMMARY.md` for exporting to a docs site.

Tell me which of the above you'd like next and I'll continue.

## Terraform CLI Cheatsheet

Quick reference of common Terraform commands, their purpose, and short examples.

- **Initialize a working directory** — install providers and initialize backend.

```bash
terraform init
```

- **Validate configuration** — checks syntax and internal consistency.

```bash
terraform validate
```

- **Format files** — rewrite files to canonical style.

```bash
terraform fmt          # format current directory
terraform fmt -recursive  # format all subdirectories
```

- **Create an execution plan** — preview changes without applying.

```bash
terraform plan -out=tfplan
```

- **Apply changes** — create/update resources (from plan or directly).

```bash
terraform apply "tfplan"         # apply previously saved plan
terraform apply -auto-approve    # apply directly without confirmation
```

- **Destroy infrastructure** — remove all resources managed by the configuration.

```bash
terraform destroy
terraform destroy -auto-approve
```

- **Show state or resource details** — inspect the current state or a saved plan.

```bash
terraform show                 # show last plan or state
terraform show tfplan          # show a saved plan file
```

- **Outputs** — read outputs defined in configuration.

```bash
terraform output               # list outputs
terraform output -raw name     # show raw value for CI scripts
```

- **State commands** — advanced: list, move, remove objects in state.

```bash
terraform state list                   # list all resources in state
terraform state mv "old" "new"      # move resource addresses
terraform state rm "resource.address" # remove from state (does not delete infra)
```

- **Import existing resources** — bring external resources into state.

```bash
terraform import aws_s3_bucket.example my-bucket-name
```

- **Mark resource for recreation** — mark as tainted so it will be replaced on next apply.

```bash
terraform taint aws_instance.web
terraform untaint aws_instance.web
```

- **Workspaces** — manage multiple state workspaces (useful for small env separation).

```bash
terraform workspace list
terraform workspace new dev
terraform workspace select prod
```

- **Graph** — generate a visual graph (requires Graphviz to render PNG/SVG).

```bash
terraform graph | dot -Tpng > graph.png
```

- **Providers and plugins** — list providers required by the configuration.

```bash
terraform providers
```

Tips:

- Use `-var` / `-var-file` to pass variables for non-interactive runs.
- Keep state secure: use remote backends (S3 + DynamoDB, Terraform Cloud) for teams.
- Use `terraform plan -out=plan` in CI to separate plan and apply steps.
