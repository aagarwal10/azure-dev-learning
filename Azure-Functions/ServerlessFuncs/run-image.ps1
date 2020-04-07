az login

$connStr = az storage account show-connection-string -g ServerlessFuncs-2 -n serverlessfuncs202004062 -o tsv

docker run -e AzureWebJobsStorage=$connStr -p 8080:80 serverlessfuncs:v2

$resourceGroup = "ServerlessFuncs-2"

az group create --name $resourceGroup --location centralus

$registryName =  "testacr19"

# create a new Azure container registry
az acr create --resource-group $resourceGroup --name $registryName --sku Basic --admin-enabled true

# log in to our container registry
az acr login --name $registryName

# get the login server name
$loginServer = az acr show -n $registryName --query loginServer --output tsv

docker image ls

# give it a new tag
docker tag serverlessfuncs:v2 $loginServer/serverlessfuncs:v2

# push the image to our Azure Container Registry
docker push $loginServer/serverlessfuncs:v2

$containerGroupName = "test-aci-serverlessfuncs"
# create a docker container using the mark heath image from dockerhub
# Do it via Portal (Azure CLI is buggy)

# see details about this container
az container show --name $containerGroupName --resource-group $resourceGroup

# view the logs
# az container logs --name $containerGroupName --resource-group $resourceGroup

# clean up everything
# az group delete --name $resourceGroup --yes
