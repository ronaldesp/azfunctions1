[CmdletBinding()]
param (
    $ApiManagementServiceName,
    $ApiManagementServiceResourceGroup
)

# az login
# az account list --output table

#Get-AzLocation | select DisplayName, Location | Format-Table

$apimServiceName = $ApiManagementServiceName
$resourceGroupName = $ApiManagementServiceResourceGroup

$resourceGroup = "rg-OPS-functions-cace"
$location = "canadacentral"
$storageAccount = "devopsstoragefunctions2"
$appServicePlan = "plan-WinApp-Ops-Functions-cace"
$functionName = "func-Ops-cf-dns-update02-cace"


# Select "DevTest-Notifications-PresenceCMS" as a Default suscription
#az account set --subscription a94e1ea6-9b1b-4f66-bcba-5ac7b8a9aad7
#Select-AzureSubscription -Default $suscriptionName


if (! (az group exists --name $resourceGroup))
{
    Write-Host "Resource group does not exists. Creating..."
    # Create a Resource Group
    az group create -n $resourceGroup -l $location # --subscription 
    Write-Host "Resource group created"
}
else {
    Write-Host "Resource group already exists"
}

if (!(Test-AzureName -Storage $storageAccount)) 
{
    Write-Host "Storage Account does not exists. Creating..."
    # Create Storage Account
    az storage account create -n $storageAccount -l $location -g $resourceGroup --sku Standard_LRS
    Write-Host "Storage Account created"
}
else {
    Write-Host "Storage Account already exists"
}


# To create an App service plan
#az appservice plan create -g rgAzFuncDevOpsLab -n AzFuncServPlan --sku S1

$planCheck = az appservice plan list --query "[?name=='$appServicePlan']" | ConvertFrom-Json
$planExists = $planCheck.Length -gt 0
if (!$planExists) {
    Write-Host "Function App does not exists. Creating..."
}
else {
    Write-Host $planCheck.Length
    Write-Host $planCheck
    Write-Host "Function App does not exists. Creating..."
}

$functionAppCheck = az functionapp list --query "[?name=='$functionName']" | ConvertFrom-Json
$functionAppExists = $functionAppCheck.Length -gt 0
if (!$functionAppExists) {
    Write-Host "Function App does not exists. Creating..."
    # Create Azure Function App
    az functionapp create -g $resourceGroup -p $appServicePlan -n $functionName  -s $storageAccount --os-type Windows --functions-version 3
    Write-Host "Function App created"
}
else {
    Write-Host $functionAppCheck.Length
    Write-Host $planCheck
}

