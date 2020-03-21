Clear-Host

# 1 - Connect to Azure
Connect-AzAccount 
#----------------------------------------------------------------------


# 2 - Create and Validate Resource Group 

$resourceGroupName = "test-rg-ps"
$location = 'Central US'

New-AzResourceGroup -Name $resourceGroupName -Location $location

Get-AzResourceGroup 
#----------------------------------------------------------------------


# 3 - Create Virtual Network (VNet) and SubNet
$vNetName = "test-vnet-ps"

$vNet = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Location $location -Name $vNetName -AddressPrefix "10.0.0.0/16" 

$subNetName = "test-subNet-ps"

Add-AzVirtualNetworkSubnetConfig -Name $subNetName -VirtualNetwork $vNet -AddressPrefix "10.0.0.0/24" | Set-AzVirtualNetwork

Get-AzVirtualNetwork
#----------------------------------------------------------------------


# 4 - Create Public IP Address

$publicIpAddressName = "test-win-pip"

New-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Name $publicIpAddressName -Location $location -AllocationMethod Static
#----------------------------------------------------------------------


# 5 - Get UserName and Password for Virtual Machine

$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

#----------------------------------------------------------------------


# 6 - Create Virtual Machine 

$VMParams = @{
 ResourceGroupName = $resourceGroupName
 Name = "test-win-VM"
 Location = $location
 Image = "Win2016Datacenter"
 VirtualNetworkName = $vNetName
 SubnetName = $subNetName
 PublicIpAddressName = $publicIpAddressName
 Credential = $cred
 OpenPorts = "3389"
}

$newVM = New-AzVM @VMParams

#----------------------------------------------------------------------

# 7 - Cleanup the Resource Group

#$job = Remove-AzResourceGroup -Name $resourceGroupName -Force -AsJob

#$job

#Wait-Job -Id $job.Id