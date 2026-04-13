project     = "opella"
environment = "prod"
location    = "westeurope"

vnet_address_space = ["10.2.0.0/16"]

subnets = {
  "vm-subnet" = {
    address_prefixes  = ["10.2.1.0/24"]
    service_endpoints = []
  }
  "storage-subnet" = {
    address_prefixes  = ["10.2.2.0/24"]
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
