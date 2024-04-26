
# Step1  ALI Transit Global 
module "mc-transit-ali" {
  source              = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version             = "2.5.3"
  account             = var.ali_global_account
  cloud               = var.ali_cloud
  region              = var.ali_global_region
  name                = var.ali_global_gw_name
  cidr                = var.ali_global_cidr
  local_as_number     = var.ali_global_localasn
  insane_mode         = false
  enable_segmentation = true
  gw_name             = var.ali_global_gw_name
  ha_gw               = var.ali_global_txha_gw
  allocate_new_eip    = true
  az_support          = false
  #enable_advertise_transit_cidr = "true"
  tags = var.tags
}



# Step2 AZ Transit Global
module "mc-transit" {
  source              = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version             = "2.5.3"
  account             = var.az_account
  cloud               = "Azure"
  resource_group      = var.az_txrg
  region              = var.az_txregion
  name                = var.az_txgateway_name
  cidr                = var.az_txcidr
  local_as_number     = var.az_localasn
  insane_mode         = "true"
  enable_segmentation = "true"
  gw_name             = var.az_txgateway_name
  ha_gw               = var.az_txha_gw
  #enable_advertise_transit_cidr = "true"
  # tags = var.tags                        # Not supported in ALI
}


#  Az Transit Global to ALI Transit Global peering
resource "aviatrix_transit_gateway_peering" "gbl_az_ali_peering" {
  transit_gateway_name1 = module.mc-transit.transit_gateway.gw_name
  transit_gateway_name2 = module.mc-transit-ali.transit_gateway.gw_name
  #gateway1_excluded_network_cidrs             = ["10.0.0.48/28"]
  #gateway2_excluded_network_cidrs             = ["10.0.0.48/28"]
  #gateway1_excluded_tgw_connections           = ["vpn_connection_a"]
  #gateway2_excluded_tgw_connections           = ["vpn_connection_b"]
  #prepend_as_path1                            = [
  #  "65001",
  #  "65001",
  #  "65001"
  #]
  #prepend_as_path2                            = [
  #  "65002"
  #]
  enable_peering_over_private_network         = false
  enable_insane_mode_encryption_over_internet = false
}



# Az Spoke Global
module "spoke_azure_1" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.6.5"
  cloud      = "Azure" # added for new mod
  transit_gw = module.mc-transit.transit_gateway.gw_name
  attached   = var.attached
  cidr       = var.az_spkcidr
  region     = var.az_spkregion
  ha_gw      = var.az_spkha_gw
  account    = var.az_account
  #insane_mode    = "false"                    # needed for bgp
  #enable_bgp     = "true"
  #local_as_number = "65058"
  resource_group = var.az_spkrg # NAME of EXISTING RG
  name           = var.az_spkgateway_name
  subnet_pairs   = "2"
  # Test out updating spoke gw RT to modify
  #included_advertised_spoke_routes = "10.185.1.0/24,10.255.185.1/32,10.255.185.2/32,10.255.185.251/32,10.255.185.252/32"
  #included_advertised_spoke_routes = "0.0.0.0/0, 10.20.0.0/24"  
  #filtered_spoke_vpc_routes = "10.185.1.0/25"
  tags = var.tags
}


module "azure-linux-vm-spoke58" {
  source = "github.com/patelavtx/azure-linux-passwd.git"
  #source = "github.com/patelavtx/terraform-azure-azure-linux-vm-public.git"
  #public_key_file = var.public_key_file
  region              = var.az_spkregion
  resource_group_name = module.spoke_azure_1.vpc.resource_group
  subnet_id           = module.spoke_azure_1.vpc.subnets[1].subnet_id
  vm_name             = "${module.spoke_azure_1.vpc.name}-vm"
}

output "spoke58-vm" {
  value = module.azure-linux-vm-spoke58
}
