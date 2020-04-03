# This uses the system-generated Managed Identity to connect
Connect-AzAccount -Identity

#Create a Storage Account Context
$context = New-AzStorageContext -StorageAccountName testrgmi -UseConnectedAccount -Verbose

#Create a Container within (fails since User Assigned Managed Identity is only at Container level and not Storage Account level)
New-AzStorageContainer -Name docstest -Context $context

#Create sample text file
echo "Hello World2!!" > hello2.txt

cat .\hello2.txt

#Upload the file to Container 
Set-AzStorageBlobContent -File .\hello2.txt -Container files -Blob helloworld2.txt -BlobType Block -Context $context -Verbose