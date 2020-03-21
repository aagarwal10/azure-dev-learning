

# Connect to Azure
az login

$resourceGroupName = "test-rg-ps"
$location = 'centralus'
$keyVaultName = "test-keyvault14"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create Key Vault
New-AzKeyVault -Name $keyVaultName -ResourceGroupName $resourceGroupName -Location $location

# Set Secret in KeyVault
$secretValue = ConvertTo-SecureString -String "ACM-PV03-CAH01:6379" -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "CacheConnection" -SecretValue $secretValue


