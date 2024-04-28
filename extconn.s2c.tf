# Setup  s2C ALI GBL -> ALI CN



############### ALI GBL to ALI CN ###############
/*
#   Used for direct bgpoipsec between ali-global and ali-cn (no vpc peering)
#Nov 6th >>    extconn.s2c.tf  >> use to Bgpoipsec and also after vpc peering for  private ip (phase1_local_identified).  

#  Opt1 - No remote g/w config
resource "aviatrix_transit_external_device_conn" "to_alicn" {
  vpc_id                    = module.mc-transit-ali.vpc.vpc_id
  connection_name           = "2alicn"
  gw_name                   = module.mc-transit-ali.transit_gateway.gw_name
  connection_type           = "bgp"
  tunnel_protocol           = "IPsec"
  bgp_local_as_num          = var.ali_global_asn
  bgp_remote_as_num         = var.ali_cn_asn
  remote_gateway_ip         = ""                         # update as AzCN applied first
  phase1_local_identifier    = "public_ip"
  pre_shared_key            = "Aviatrix123#"
  enable_ikev2              = "false"
  local_tunnel_cidr         = "${local.ali_gbl_apipa1}/30, ${local.ali_gbl_apipa2}/30"
  remote_tunnel_cidr        = "${local.ali_cn_apipa1}/30, ${local.ali_cn_apipa2}/30"
  #ha_enabled                = "true"
  #backup_remote_gateway_ip  = "20.31.84.218"
  #backup_bgp_remote_as_num  = "65515"
  #backup_pre_shared_key     = "Aviatrix123#"
  #backup_local_tunnel_cidr  = "169.254.21.205/30, 169.254.22.205/30"
  #backup_remote_tunnel_cidr = "169.254.21.206/30, 169.254.22.206/30"
}
*/


# Opt2 - Test with remote gateway configured
#Note/.  Issue with accessing vpc peering on ALI, need to chase G.Lam.
resource "aviatrix_transit_external_device_conn" "to_alicn" {
  vpc_id                    = module.mc-transit-ali.vpc.vpc_id
  connection_name           = "2alicn"
  gw_name                   = module.mc-transit-ali.transit_gateway.gw_name
  connection_type           = "bgp"
  tunnel_protocol           = "IPsec"
  bgp_local_as_num          = var.ali_global_asn
  bgp_remote_as_num         = var.ali_cn_asn
  remote_gateway_ip         = "120.26.141.76, 112.124.61.52"
  phase1_local_identifier    = "public_ip"
  pre_shared_key            = "Aviatrix123#"
  enable_ikev2              = "false"
  local_tunnel_cidr         = "${local.ali_gbl_apipa1}/30, ${local.ali_gbl_apipa2}/30"
  remote_tunnel_cidr        = "${local.ali_cn_apipa1}/30, ${local.ali_cn_apipa2}/30"
  #ha_enabled                = "true"
  #backup_remote_gateway_ip  = "20.31.84.218"
  #backup_bgp_remote_as_num  = "65515"
  #backup_pre_shared_key     = "Aviatrix123#"
  #backup_local_tunnel_cidr  = "169.254.21.205/30, 169.254.22.205/30"
  #backup_remote_tunnel_cidr = "169.254.21.206/30, 169.254.22.206/30"
}



/*
# Opt3a - Test with vpc peering using private ips
resource "aviatrix_transit_external_device_conn" "to_alicn" {
  vpc_id                    = module.mc-transit-ali.vpc.vpc_id
  connection_name           = "2alicn"
  gw_name                   = module.mc-transit-ali.transit_gateway.gw_name
  connection_type           = "bgp"
  tunnel_protocol           = "IPsec"
  bgp_local_as_num          = var.ali_global_asn
  bgp_remote_as_num         = var.ali_cn_asn
  remote_gateway_ip         = "10.4.28.2, 10.4.28.19"
  phase1_local_identifier    = "private_ip"
  pre_shared_key            = "Aviatrix123#"
  enable_ikev2              = "false"
   local_tunnel_cidr         = "${local.ali_gbl_apipa1}/30, ${local.ali_gbl_apipa2}/30"
  remote_tunnel_cidr        = "${local.ali_cn_apipa1}/30, ${local.ali_cn_apipa2}/30"
}
*/


