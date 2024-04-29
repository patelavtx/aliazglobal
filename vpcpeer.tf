


# route table entries stuff
# https://www.alibabacloud.com/help/en/vpc/route-table-overview
# https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/route_entry#VpcPeer




##############################
# Existing acceptor is azCN-tx
##############################
data "alicloud_account" "accepting" {
  provider = alicloud.china
}


# Existing acceptor vpc details
data "alicloud_vpcs" "accepting_vpc" {
  provider   = alicloud.china
  vpc_name   = var.ali_cn_vpcname
  cidr_block = var.ali_cn_cidr
}

output "alicn_vpc_details" {
  value = "${data.alicloud_vpcs.accepting_vpc}"
}


# vpc conns 
resource "alicloud_vpc_peer_connection" "default" {
  provider             = alicloud.global
  peer_connection_name = "to-alicn"
  vpc_id               = module.mc-transit-ali.vpc.vpc_id
  accepting_ali_uid    = data.alicloud_account.accepting.id
  accepting_region_id  = "cn-hangzhou"        #  ali syntax, avtx prepends 'acs'
  accepting_vpc_id     = data.alicloud_vpcs.accepting_vpc.vpcs[0].id
  description          = "Conn-2-alicn"
}


############################
# route table entries stuff
############################
# https://www.alibabacloud.com/help/en/vpc/route-table-overview
# https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/route_entry#VpcPeer


#  get initiator vpc route table id
data "alicloud_route_tables" "aliglobal" {
  provider = alicloud.global
  vpc_id = module.mc-transit-ali.vpc.vpc_id
}

output "route_table_tables" {
  value = "${data.alicloud_route_tables.aliglobal.tables}"
}

output "route_table_ids" {
  value = "${data.alicloud_route_tables.aliglobal.ids}"
}



# ACCEPTOR
#  get acceptor vpc route table id
data "alicloud_route_tables" "alicn" {
  provider = alicloud.china
  vpc_id = data.alicloud_vpcs.accepting_vpc.vpcs[0].id
}

output "alicn_route_table_tables" {
  value = "${data.alicloud_route_tables.alicn.tables}"
}

output "alicn_route_table_ids" {
  value = "${data.alicloud_route_tables.alicn.ids}"
}


# Create route entries

# In ali_bgl
resource "alicloud_route_entry" "alicn" {
  provider = alicloud.global                                 # needed alias ; without didn't find RT
  route_table_id        =  "${data.alicloud_route_tables.aliglobal.tables[0].route_table_id}"
  destination_cidrblock = data.alicloud_vpcs.accepting_vpc.cidr_block
  nexthop_type          = "VpcPeer"
  nexthop_id            = "${alicloud_vpc_peer_connection.default.id}"
}

# In ali_cn
resource "alicloud_route_entry" "toaliglobal" {
  provider = alicloud.china
  route_table_id        = "${data.alicloud_route_tables.alicn.tables[0].route_table_id}"
  destination_cidrblock = module.mc-transit-ali.vpc.cidr
  nexthop_type          = "VpcPeer"
  nexthop_id            = "${alicloud_vpc_peer_connection.default.id}"
}





