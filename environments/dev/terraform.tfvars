project     = "opella"
environment = "dev"
location    = "eastus"

vnet_address_space = ["10.1.0.0/16"]

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

vm_size           = "Standard_D2a_v4"
vm_admin_username = "azureuser"

tags = {
  owner      = "gustavo"
  department = "devops"
  costcenter = "opella-challenge"
}
