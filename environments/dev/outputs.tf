output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = module.vnet.vnet_name
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = module.vnet.subnet_ids
}

output "storage_account_name" {
  description = "Name of the Storage Account"
  value       = azurerm_storage_account.this.name
}

output "vm_name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.this.name
}

output "vm_private_ip" {
  description = "Private IP address of the Virtual Machine"
  value       = azurerm_network_interface.this.private_ip_address
}
