# ALIAZGLOBAL

Example of Aviatrix China GLOBAL deployment;  can be used in conjuction with repo 'ALIAZCHINA' to facilitate 'end to end' setup for testing.
Recommended procedure is to deploy ALIAZCHINA first then ALIAZGLOBAL



- ![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) `'inter ALICloud region leveraging vpc peering' with S2C (BGPoIPSEc) overlay (note/ BGPoLAN not supported by ALI)`

- ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) `Works well with better throughput due to vpc peering`



There are a few options on connecting to China:

- OPT1:- Europe Azure Transit >  S2C < China Azure Transit
- OPT2:- Europe Azure Transit >  Europe Ali Transit > S2C < China Ali Transit < China Azure Transit
- OPT3:- As above but with   Europe Ali Transit > S2C/VPC Peering < China Ali Transit   


## Architecture
![Architecture](https://github.com/patelavtx/LabShare/blob/main/AviatrixChina-gbl.PNG)




## Terraform code description

Summary of the *tf files, the code itself has some additional comments
- Variables.tf has most variables set to some 'default'
- See '####


**TF files**


 ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) `'main.tf' `             
 
- Step1
  - ALI Global Aviatrix Transit 

- Step2
  - Azure Aviatrix transit 
  - Aviatrix Transit peering (Az transit + ALI Transit)

- Step3
  - Azure CN Spoke 
  - Azure Test Linux VM



![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) `'vpcpeer.tf' `

- ALI Global to ALI China vpc peering
  - Initiator vpc is Global
  - Acceptor vpc is China

- ALI transit Global and China Route table updates
  - Route entry from Global to China via peering conn
  - Route entry from China to Global via peering



 ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) `'extconn.s2c.tf' `        

 - Provides opt1-opt3, setup for opt3
 - Since 'ALi Transit China transit' private ips are not known, will need to update and re-apply Terraform after initial run
 
 

## Validated environment
```
Terraform v1.8.2  
on linux_amd64 (WSL) and TFC workspace
+ provider aviatrixsystems/aviatrix v3.1.0

```



## China ENV VARS to set

**ALI**

```
export ALICLOUD_REGION=cn-hangzhou
export ALICLOUD_SECRET_KEY=
export ALICLOUD_ACCESS_KEY=

```


**AZURE**

If running locally,  ensure you set the Azure cloud : **az cloud set -n AzureCloud**
Also **remove the ARM_ENDPOINT for China.**


```
export ARM_CLIENT_ID=
export ARM_TENANT_ID=
export ARM_CLIENT_SECRET=
export ARM_SUBSCRIPTION_ID=

```


## Example of terraform TFVARS

- Variables.tf has most defaults set for easy deployment, check the settings.
- The following variables were added to *tfvars and is highlighted here for 'visibility'

  - ali_cloud
  - ali_cn_cidr
  - ali_cn_vpcname
  - ali_global_account
  - ali_global_cidr
  - ali_global_gw_name
  - ali_global_localasn
  - ali_global_region
  - ali_global_txha_gw
  - alisyntax_cn_region
  - az_account
  - az_cloud
  - az_localasn
  - az_spkcidr
  - az_spkgateway_name
  - az_spkha_gw
  - az_spkregion
  - az_spkrg
  - az_txcidr
  - az_txgateway_name
  - az_txha_gw
  - az_txregion
  - az_txrg
  - controller_ip
  - ctrl_password
