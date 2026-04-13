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
## Notes

## Notes

- DDoS protection is disabled by default (~$2,944/month extra). Enable only for production workloads that require it.
- Subnets support Azure Service Endpoints for secure access to Azure services without exposing traffic to the internet.
- Documentation is auto-generated using [terraform-docs](https://terraform-docs.io):
```bash
  terraform-docs markdown table --output-file README.md --output-mode inject modules/vnet/
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_ddos_protection_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | List of address spaces for the VNET | `list(string)` | <pre>[<br/>  "10.0.0.0/16"<br/>]</pre> | no |
| <a name="input_enable_ddos_protection"></a> [enable\_ddos\_protection](#input\_enable\_ddos\_protection) | Enable DDoS protection plan on the VNET | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the VNET will be deployed | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Virtual Network | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Resource Group where the VNET will be created | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets to create inside the VNET | <pre>map(object({<br/>    address_prefixes  = list(string)<br/>    service_endpoints = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | Map of subnet names to their address prefixes |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet names to their IDs |
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | The address space of the Virtual Network |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The ID of the Virtual Network |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | The name of the Virtual Network |
<!-- END_TF_DOCS -->
