# COMMON
variable "controller_ip" {
  description = "Set controller ip"
  type        = string
}

variable "ctrl_password" {
    type = string
}

variable "tags" {
  description = "Map of tags to assign to the gateway."
  type        = map(string)
  default     = null
}


# Step1 ALI Global
variable "ali_cloud" {
  description = "Cloud type"
  type        = string

  validation {
    condition     = contains(["aws", "azure", "oci", "ali", "gcp"], lower(var.ali_cloud))
    error_message = "Invalid cloud type. Choose AWS, Azure, GCP, ALI or OCI."
  }
}

#  Allow for changing instance size
/*
variable "instance_size" {
  description = "Set vpc cidr"
  type        = string
}
*/

variable "ali_cn_region" {
  description = "Set regions"
  type        = string
  default = "acs-cn-beijing (Beijing)" 
}


variable "ali_global_region" {
    type = string
    description = "Alibaba Global Cloud Region Name"
}

variable "ali_global_account" {
    type = string
    description = "Alibaba Global gw"
}
variable "ali_global_gw_name" {
    type = string
    description = "Alibaba Global gw"
}

variable "ali_global_cidr" {
    type = string
    description = "Alibaba Global cidr"
}

variable "ali_global_localasn" {
    type = string
    description = "Alibaba Global asn"
}

variable "ali_global_txha_gw" {
  description = ""
  type        = string
}

variable "ali_cn_cidr" {
    type = string
    description = ""
}

variable "alisyntax_cn_region" {
    type = string
    description = ""
}

variable "ali_cn_vpcname" {
    type = string
    description = ""
}

variable "ali_cn_asn" {
  description = "Set internal BGP ASN"
  type        = string
  default = "65004"
}

variable "ali_global_asn" {
  description = "Set internal BGP ASN"
  type        = string
  default = "65040"
}



locals {
  peer_conn = "${var.ali_global_region}-${var.ali_cn_region}"
}







# Step2 AZ Global Transit
variable "az_account" {
    type = string
}

variable "az_cloud" {
  description = "Cloud type"
  type        = string

  validation {
    condition     = contains(["aws", "azure", "oci", "ali", "gcp"], lower(var.az_cloud))
    error_message = "Invalid cloud type. Choose AWS, Azure, GCP, ALI or OCI."
  }
}

variable "az_txcidr" {
  description = "Set vpc cidr"
  type        = string
}

#  for instance size changes
/*
variable "az_tx_instance_size" {
  description = "Set vpc cidr"
  type        = string
}
*/
variable "az_txregion" {
  description = "Set regions"
  type        = string
}


variable "az_localasn" {
  description = "Set internal BGP ASN"
  type        = string
}

variable "az_txrg" {
  description = "Set RG"
  type        = string
}


variable "az_txgateway_name" {
  description = ""
  type        = string
}


variable "az_txha_gw" {
  description = ""
  type        = string
}


# Step3 Az Spoke


variable "az_spkcidr" {
  description = "Set vpc cidr"
  type        = string
}

#  for instance size changes
/*
variable "az_spk_instance_size" {
  description = "Set vpc cidr"
  type        = string
}
*/
variable "az_spkregion" {
  description = "Set regions"
  type        = string
}

variable "az_spkrg" {
  description = "Set RG"
  type        = string
}

variable "az_spkgateway_name" {
  description = ""
  type        = string
}

variable "az_spkha_gw" {
  description = ""
  type        = string
}

variable "nat_attached" {
  default     = "true"
}

variable "attached" {
  default     = "true"
}

variable "apipa1" {
  description = "Provide CSR vNet address space"
  default = "169.254.31.201/30"
}


variable "apipa2" {
  description = "Provide CSR vNet address space"
  default = "169.254.32.202/30"
}

locals {
  ali_gbl_apipa1 = cidrhost(var.apipa1,1)
  ali_gbl_apipa2 = cidrhost(var.apipa2,1)
  ali_cn_apipa1 = cidrhost(var.apipa1,2)
  ali_cn_apipa2 = cidrhost(var.apipa2,2)
 }