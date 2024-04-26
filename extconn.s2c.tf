# Setup  s2C ALI GBL -> ALI CN

#   fine tune later - but for s2c connectivity instead of vpc peering between ali cn and ali global
resource "aviatrix_transit_external_device_conn" "to_alicn" {
  #  vpcid and transit gateway variable values can be found via the transit gateway output
  vpc_id                    = module.mc-transit-ali.vpc.vpc_id
  connection_name           = "2alicn"
  gw_name                   = module.mc-transit-ali.transit_gateway.gw_name
  connection_type           = "bgp"
  tunnel_protocol           = "IPsec"
  bgp_local_as_num          = var.ali_global_asn
  bgp_remote_as_num         = var.ali_cn_asn
  #backup_bgp_remote_as_num  = "65515"
  #ha_enabled                = "true"
  #remote_gateway_ip         = "47.94.146.45"
  remote_gateway_ip = "10.4.28.12"
  phase1_local_identifier = "private_ip"
  #backup_remote_gateway_ip  = "20.31.84.218"
  pre_shared_key            = "Aviatrix123#"
  #backup_pre_shared_key     = "Aviatrix123#"
  enable_ikev2              = "false"
  local_tunnel_cidr         = "${local.ali_gbl_apipa1}/30, ${local.ali_gbl_apipa2}/30"
  remote_tunnel_cidr        = "${local.ali_cn_apipa1}/30, ${local.ali_cn_apipa2}/30"
}



# Setup  s2C ALI CN -> ALI GBL
resource "aviatrix_transit_external_device_conn" "to_aliglobal" {
  #  vpcid and transit gateway variable values can be found via the transit gateway output
  vpc_id                    = var.ali_cn_vpcname
  connection_name           = "2aligbl"
  gw_name                   = var.ali_cn_vpcname
  connection_type           = "bgp"
  tunnel_protocol           = "IPsec"
  bgp_local_as_num          = var.ali_cn_asn
  bgp_remote_as_num         = var.ali_global_asn
  #backup_bgp_remote_as_num  = "65515"
  #ha_enabled                = "true"
  #remote_gateway_ip         = "47.91.91.120"
  remote_gateway_ip          = "10.40.28.4"                               # need to man
  phase1_local_identifier    = "private_ip"
  #backup_remote_gateway_ip  = "20.31.84.218"
  pre_shared_key            = "Aviatrix123#"
  #backup_pre_shared_key     = "Aviatrix123#"
  enable_ikev2              = "false"
  remote_tunnel_cidr         = "${local.ali_gbl_apipa1}/30, ${local.ali_gbl_apipa2}/30"
  local_tunnel_cidr        = "${local.ali_cn_apipa1}/30, ${local.ali_cn_apipa2}/30"
}


