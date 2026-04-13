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

vm_size                = "Standard_B1s"
vm_admin_username      = "azureuser"
vm_ssh_public_key_path = "~/.ssh/id_rsa.pub"

tags = {
  owner      = "gustavo"
  department = "devops"
  costcenter = "opella-challenge"
}
