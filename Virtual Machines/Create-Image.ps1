Clear-Host

# 1 - Connect to Azure
az login 

$resourceGroupName = "test-rg-ps"
$vmName = "test-win-VM"
$location = 'centralus'

#Open and RDP session to this Windows VM and run this command in a command prompt. 
#This will Generalize the VM and shut it down.    
%WINDIR%\system32\sysprep\sysprep.exe /generalize /shutdown /oobe

#Let's get the status of our VM and ensure it's shut down first.
az vm list --resource-group $resourceGroupName --show-details --output table

#In Azure CLI, deallocate the virtual machine
az vm deallocate --resource-group $resourceGroupName --name 

#Check out the status of our virtual machine
az vm list --show-details --output table

#Mark the virtual machine as "generalized"
az vm generalize --resource-group $resourceGroupName --name $vmName

#Create an Image from the generalized 
$imageName = "test-win-VM-image"
az image create --resource-group $resourceGroupName --source $vmName --name $imageName

#List image(s) information
az image list --output table

az vm create `
     --resource-group $resourceGroupName `
     --location $location --name "test-win-cim" `
     --image $imageName `
     --admin-username "myadmin" `
     --admin-password "Ddlgsrkk1959" `
     --nsg-rule "RDP"

#Check out the status of our virtual machine
az vm list --show-details --output table

#Try to start our generalized image, you cannot. 
#If you want to keep the source VM around...then copy the VM, generalize the copy and continue to use the source VM.
az vm start --name $vmName --resource-group $resourceGroupName

#You can delete the deallocated source VM
az vm delete --name $vmName --resource-group $resourceGroupName

#List Image in our Resource Group as a managed resource.
az resource list --resource-type=Microsoft.Compute/images --output table

az group delete --name $resourceGroupName