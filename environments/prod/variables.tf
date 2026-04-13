variable "project" {
  description = "Project name, used for naming and tagging resources"
  type        = string
  default     = "opella"
}

variable "environment" {
  description = "Environment name (dev, prod, staging...)"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "westeurope"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets to create inside the VNET"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
  }))
  default = {
    "vm-subnet" = {
      address_prefixes  = ["10.2.1.0/24"]
      service_endpoints = []
    }
    "storage-subnet" = {
      address_prefixes  = ["10.2.2.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
  }
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_B2s"
}

variable "vm_admin_username" {
  description = "Admin username for the Virtual Machine"
  type        = string
  default     = "azureuser"
}

variable "vm_ssh_public_key_path" {
  description = "Path to the SSH public key file for VM authentication"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
