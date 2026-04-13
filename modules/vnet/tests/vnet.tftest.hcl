provider "azurerm" {
  features {}
}

variables {
  name                = "vnet-test"
  resource_group_name = "rg-test"
  location            = "westus2"
  address_space       = ["10.99.0.0/16"]
  subnets = {
    "test-subnet" = {
      address_prefixes  = ["10.99.1.0/24"]
      service_endpoints = []
    }
  }
  tags = {
    environment = "test"
    managed_by  = "terraform"
  }
}

run "vnet_has_correct_address_space" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.address_space == toset(["10.99.0.0/16"])
    error_message = "VNET address space does not match expected value"
  }
}

run "vnet_has_correct_name" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-test"
    error_message = "VNET name does not match expected value"
  }
}

run "vnet_has_correct_location" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.location == "westus2"
    error_message = "VNET location does not match expected value"
  }
}

run "subnet_has_correct_cidr" {
  command = plan

  assert {
    condition     = tolist(azurerm_subnet.this["test-subnet"].address_prefixes)[0] == "10.99.1.0/24"
    error_message = "Subnet CIDR does not match expected value"
  }
}

run "ddos_protection_disabled_by_default" {
  command = plan

  assert {
    condition     = length(azurerm_network_ddos_protection_plan.this) == 0
    error_message = "DDoS protection should be disabled by default"
  }
}

run "ddos_protection_enabled_when_requested" {
  command = plan

  variables {
    enable_ddos_protection = true
  }

  assert {
    condition     = length(azurerm_network_ddos_protection_plan.this) == 1
    error_message = "DDoS protection plan should be created when enabled"
  }
}
