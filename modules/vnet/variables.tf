variable "name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where the VNET will be created"
  type        = string
}

variable "location" {
  description = "Azure region where the VNET will be deployed"
  type        = string
}

variable "address_space" {
  description = "List of address spaces for the VNET"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets to create inside the VNET"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
  }))
  default = {}
}

variable "enable_ddos_protection" {
  description = "Enable DDoS protection plan on the VNET"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
