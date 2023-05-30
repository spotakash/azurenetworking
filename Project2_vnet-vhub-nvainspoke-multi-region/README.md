## Pattern Using (Route traffic through an NVA)
This pattern is using [Route traffic through an NVA](https://learn.microsoft.com/en-us/azure/virtual-wan/scenario-route-through-nva) Capability around Azure virtual WAN Topology.

In this repo, a sample code is being developed and tested for below high level design to build and test Route traffice through NVA (NVA in Spoke) across multiple Region using Virtual Wan HUB

- In thi pattern Azure Firewall is being used as NVA in SPOKE
- Also used NAT Gateway from specific Nested Spoke VNET to Internet Outbound. It is being to avoid *[SNAT port exhaustion and use it along side Azure Firewall](https://azure.microsoft.com/en-us/blog/scale-azure-firewall-snat-ports-with-nat-gateway-for-large-workloads/)* 
<img src="/Project2_vnet-vhub-nvainspoke-multi-region/NVA_in_SPOKE_vWAN.jpg" alt="High Level Design" width=70% height=70%>

*This particular pattern is very useful if cusomter is using 3rd Party Network Virtual Appliance and wants all type of traffic to be inspected/controlled by those NVAs. Although Azure vWAN now even support various type of [3rd Party NVA](https://learn.microsoft.com/en-us/azure/virtual-wan/about-nva-hub#partners), sometime customer are standardized on specific NVA across global deployment and wants to use same control/management console. In that case, NVA spoke model come handy and go-forward pattern*

- #### Key Facets used in this sample for code optimization
  1. **(Optional)** [Azure Firewall with NAT Gateway](https://learn.microsoft.com/en-us/azure/nat-gateway/tutorial-hub-spoke-nat-firewall): To bring unification on certails rules and optimize manual effort for different region Firewall Policy.
  2. [Virtual Hub Conenction](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection): Due to limitation of accessible of 3rd party NVA trial license, Azure Firewall `Premium` is being used. Therefore, normal **`virtual hub connection`** is being used ([provider used](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection)). When using 3rd Party NVA in Spoke, using **`virtual hub bgp conenction`** should be used ([provider should be used](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_bgp_connection)).
  3. [Azure Firewall Parent and Child Policy](https://learn.microsoft.com/en-us/azure/firewall-manager/policy-overview#hierarchical-policies): To bring unification on certails rules and optimize manual effort for different region Firewall Policy.

- ##### *Review [Routing Intent Project](Project3_vWAN_RoutingIntent) for how <u>Terraform Map Function, IP Group</u> can simplify lot of work*

********************
### *Cost Optimization*
##### *Variabalize (sample)*
```
$azfw = Get-AzFirewall -Name "FW Name" -ResourceGroupName "RG Name"
$vnet = Get-AzVirtualNetwork -ResourceGroupName "RG Name" -Name "VNet Name"
$publicip1 = Get-AzPublicIpAddress -Name "Public IP1 Name" -ResourceGroupName "RG Name"
$publicip2 = Get-AzPublicIpAddress -Name "Public IP2 Name" -ResourceGroupName "RG Name"
$azfw.Allocate($vnet,@($publicip1,$publicip2))

```
##### *Stop Firewall (sample without variable)*

```
$asiafirewall = Get-AzFirewall -Name "eastasia-fw" -ResourceGroupName "asia_networking"
$asiafirewall.Deallocate()
$asiafirewall | Set-AzFirewall

$eufirewall = Get-AzFirewall -Name "westeurope-fw" -ResourceGroupName "eu_networking"
$eufirewall.Deallocate()
$eufirewall | Set-AzFirewall
```
##### *Start Firewall (sample without variable)*
```
$asiafirewall = Get-AzFirewall -Name "eastasia-fw" -ResourceGroupName "asia_networking"
$asiafirewallvnet = Get-AzVirtualNetwork -ResourceGroupName "asia_networking" -Name "Secured-NVA-VNET-Asia"
$asiafwpublicip1 = Get-AzPublicIpAddress -Name "eastasia-fw-pip" -ResourceGroupName "asia_networking"
$asiafirewall.Allocate($asiafirewallvnet,@($asiafwpublicip1))
Set-AzFirewall -AzureFirewall $asiafirewall

$eufirewall = Get-AzFirewall -Name "westeurope-fw" -ResourceGroupName "eu_networking"
$eufirewallvnet = Get-AzVirtualNetwork -ResourceGroupName "eu_networking" -Name "Secured-NVA-VNET-EU"
$eufwpublicip1 = Get-AzPublicIpAddress -Name "westeurope-fw-pip" -ResourceGroupName "eu_networking"
$eufirewall.Allocate($eufirewallvnet,@($eufwpublicip1))
Set-AzFirewall -AzureFirewall $eufirewall
```
