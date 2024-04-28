
# acceptor is azCN-tx
data "alicloud_account" "accepting" {
  provider = alicloud.china
}

# acceptor vpc details
resource "alicloud_vpc" "accepting_vpc" {
  provider   = alicloud.china
  vpc_name   = var.ali_cn_vpcname
  cidr_block = var.ali_cn_cidr
}

# vpc conns
resource "alicloud_vpc_peer_connection" "default" {
  provider             = alicloud.global
  peer_connection_name = "peerconn1"
  vpc_id               = module.mc-transit-ali.vpc.vpc_id
  accepting_ali_uid    = data.alicloud_account.accepting.id
  accepting_region_id  = var.alisyntax_cn_region       #  ali syntax, avtx prepends 'acs'
  accepting_vpc_id     = alicloud_vpc.accepting_vpc.id
  description          = local.peer_conn
}



# route table entries stuff
# https://www.alibabacloud.com/help/en/vpc/route-table-overview
# https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/route_entry#VpcPeer


#  get initiator vpc route table id
data "alicloud_route_tables" "aliglobal" {
  provider = alicloud.global
  #vpc_id = "vpc-gw8mf0dq13lehyzmvx8zf"
  vpc_id = module.mc-transit-ali.vpc.vpc_id
}

output "route_table_tables" {
  value = "${data.alicloud_route_tables.aliglobal.tables}"
}

output "route_table_ids" {
  value = "${data.alicloud_route_tables.aliglobal.ids}"
}


resource "alicloud_route_entry" "toaliglobal" {
  provider = alicloud.china
  route_table_id        = "${alicloud_vpc.accepting_vpc.router_table_id}"
  destination_cidrblock = var.ali_global_cidr
  nexthop_type          = "VpcPeer"
  nexthop_id            = "${alicloud_vpc_peer_connection.default.id}"
}


resource "alicloud_route_entry" "alicn" {
  provider = alicloud.global                                 # needed provider ; without didn't find RT
  route_table_id        =  "${data.alicloud_route_tables.aliglobal.tables[0].route_table_id}"
  destination_cidrblock = var.ali_cn_cidr
  nexthop_type          = "VpcPeer"
  nexthop_id            = "${alicloud_vpc_peer_connection.default.id}"
}






