# Module: VNET

Reusable Terraform module to deploy an Azure Virtual Network (VNET) with subnets.

## Usage

```hcl
module "vnet" {
  source = "../../modules/vnet"

  name                = "vnet-opella-dev-eastus"
  resource_group_name = "rg-opella-dev-eastus"
  location            = "eastus"
  address_space       = ["10.1.0.0/16"]

  subnets = {
    "vm-subnet" = {
      address_prefixes  = ["10.1.1.0/24"]
      service_endpoints = []
    }
    "storage-subnet" = {
      address_prefixes  = ["10.1.2.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
  }

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| azurerm | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the Virtual Network | `string` | n/a | yes |
| resource\_group\_name | Name of the Resource Group | `string` | n/a | yes |
| location | Azure region | `string` | n/a | yes |
| address\_space | Address space for the VNET | `list(string)` | `["10.0.0.0/16"]` | no |
| subnets | Map of subnets to create | `map(object)` | `{}` | no |
| enable\_ddos\_protection | Enable DDoS protection plan | `bool` | `false` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vnet\_id | The ID of the Virtual Network |
| vnet\_name | The name of the Virtual Network |
| vnet\_address\_space | The address space of the Virtual Network |
| subnet\_ids | Map of subnet names to their IDs |
| subnet\_address\_prefixes | Map of subnet names to their address prefixes |

## Notes

- DDoS protection is disabled by default as it has an additional cost (~$2,944/month). Enable only for production workloads that require it.
- Subnets support Azure Service Endpoints for secure access to Azure services like Storage or KeyVault without exposing traffic to the internet.
