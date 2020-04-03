# This uses the system-generated Managed Identity to connect
Connect-AzAccount -MSI 

#Create a Storage Account Context
$context = New-AzStorageContext -StorageAccountName testrgmi -UseConnectedAccount

#Create a Container within
New-AzStorageContainer -Name docs -Context $context

#Create sample text file
echo "Hello World!!" > hello.txt

cat .\hello.txt

#Upload the file to Container 
Set-AzStorageBlobContent -File .\hello.txt -Container docs -Blob helloworld.txt -BlobType Block -Context $context -Verbose

