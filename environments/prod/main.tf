terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstateopella"
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.project}-${var.environment}-${var.location}"
  location = var.location
  tags     = local.tags
}

module "vnet" {
  source = "../../modules/vnet"

  name                = "vnet-${var.project}-${var.environment}-${var.location}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  address_space       = var.vnet_address_space
  subnets             = var.subnets
  tags                = local.tags
}

resource "azurerm_storage_account" "this" {
  name                     = "st${var.project}${var.environment}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = local.tags
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = "vm-${var.project}-${var.environment}"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  disable_password_authentication = true
  tags                            = local.tags

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.vm_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "this" {
  name                = "nic-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  tags                = local.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids["vm-subnet"]
    private_ip_address_allocation = "Dynamic"
  }
}

locals {
  tags = merge(var.tags, {
    environment = var.environment
    project     = var.project
    region      = var.location
    managed_by  = "terraform"
  })
}

resource "azurerm_resource_group_policy_assignment" "require_tags" {
  name                 = "require-tags-${var.environment}"
  resource_group_id    = azurerm_resource_group.this.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"

  display_name = "Require mandatory tags on resources"
  description  = "Enforces that all resources have the required tags: environment, project, managed_by"

  parameters = jsonencode({
    tagName = {
      value = "environment"
    }
  })
}
