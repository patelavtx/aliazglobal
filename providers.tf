# Configure Aviatrix provider
provider "aviatrix" {
  controller_ip           = var.controller_ip
  username                = "admin"
  password                = var.ctrl_password
}

provider "alicloud" {
  alias = "china"
  region = "cn-hangzhou"
  #skip_region_validation = "true"
}

provider "alicloud" {
  alias = "global"
  region = "eu-central-1"
}

provider azurerm {
    skip_provider_registration = "true"
    features {}    
}



