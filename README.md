# Opella DevOps Challenge — Azure IaC with Terraform

This repository contains the solution to the Opella DevOps Technical Challenge.
It provisions Azure infrastructure using Terraform, emphasizing reusable, secure, and maintainable IaC.

## Repository Structure

.
├── modules/
│   └── vnet/          # Reusable Azure VNET module
├── environments/
│   ├── dev/           # Development environment (eastus)
│   └── prod/          # Production environment (westeurope)
└── .github/
└── workflows/
├── terraform-plan.yml   # Triggered on Pull Request
└── terraform-apply.yml  # Triggered on merge to main

## Architecture Decisions

### Resource Groups vs Subscriptions
Resource Groups are used to isolate environments (dev/prod). This is the pragmatic choice
for a single-project setup — simpler to manage, same cost, sufficient isolation.
Subscriptions would be the right choice in an enterprise context with strict billing
separation, compliance boundaries, or multiple teams.

### Environment Differences

| Resource        | Dev                  | Prod                  |
|----------------|----------------------|-----------------------|
| Location        | eastus               | westeurope            |
| VM Size         | Standard_B1s         | Standard_B2s          |
| OS Disk         | Standard_LRS         | Premium_LRS           |
| Storage         | LRS (local)          | GRS (geo-redundant)   |
| VNET Range      | 10.1.0.0/16          | 10.2.0.0/16           |

### Naming Convention
All resources follow the pattern: `{type}-{project}-{environment}-{region}`
Example: `vnet-opella-dev-eastus`, `rg-opella-prod-westeurope`

### Tagging Strategy
All resources are tagged with:
- `environment` — dev / prod
- `project` — opella
- `region` — azure region
- `managed_by` — terraform
- `owner`, `department`, `costcenter` — via tfvars

## Release Lifecycle
feature branch
│
▼
Pull Request → terraform plan runs automatically (dev + prod)
│
▼
Code Review + Plan Review
│
▼
Merge to main → terraform apply dev
│
▼ (needs: dev apply success)
terraform apply prod

## Code Quality Tools

| Tool                  | Purpose                              |
|-----------------------|--------------------------------------|
| `terraform fmt`       | Code formatting                      |
| `terraform validate`  | Syntax and logic validation          |
| `tflint`              | Linting and best practices           |
| `terraform-docs`      | Auto-generate module documentation   |
| `pre-commit`          | Enforce all checks before every commit |
| `checkov`             | Security scanning of IaC             |

## Usage

### Prerequisites
- Terraform >= 1.3.0
- Azure CLI
- An Azure subscription

### Authentication
```bash
az login
az account set --subscription "<your-subscription-id>"
```

### Deploy Dev Environment
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### Deploy Prod Environment
```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

## Modules

### VNET Module
See [modules/vnet/README.md](modules/vnet/README.md) for full documentation.
