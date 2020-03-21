Clear-Host

# 1 - Connect to Azure
az login 

# 2 - Attach the new disk

$resourceGroupName = "test-rg-ps"
$vmName = "test-win-VM"
$diskName = "test-vm-disk"

#az vm disk attach --resource-group $resourceGroupName --vm-name $vmName --name $diskName --new --size-gb 25 --sku "Standard_LRS"

# 3 - Prepare the disk for use by the operating system
az vm list-ip-addresses --name $vmName --output table
#------------------------------------------------------------------------------

#Resizing a disk
#1 - Stop and deallocate the VM. this has to be an offline operation.
az vm deallocate --resource-group $resourceGroupName --name $vmName

#2 - Find the disk's name we want to expand
az disk list --output table

#3 - Update the disk's size to the desired size
az disk update --resource-group $resourceGroupName --name $diskName --size-gb 100

#4 - start up the VM again
az vm start --resource-group $resourceGroupName --name $vmName

#5 - Log into the guest OS and resize the volume
az vm list-ip-addresses --name $vmName --output table

#2 - Detaching the disk from the virtual machine. This can be done online too!
az vm disk detach --resource-group $resourceGroupName --vm-name $vmName --name diskName

#3 - Delete the disk
az disk delete --resource-group $resourceGroupName --name $diskName