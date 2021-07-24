[CmdletBinding()]
param (
    $ResourceGroupName='rg-OPS-functions-cace',
    $LocationName='canadacentral',
    $storageAccountName='devopsstoragefunctions2',
    $appServicePlanName='plan-WinApp-Ops-Functions-cace',
    $functionAppName='func-Ops-cf-dns-update02-cace'
)

$resourceGroup = $ResourceGroupName
$location = $LocationName
$storageAccount = $storageAccountName
$appServicePlan = $appServicePlanName
$functionApp = $functionAppName

Write-Host "resourceGroup: " $resourceGroup
Write-Host "location: " $location
Write-Host "storageAccount: " $storageAccount
Write-Host "appServicePlan: " $appServicePlan
Write-Host "functionApp: " $functionApp

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

$functionAppCheck = az functionapp list --query "[?name=='$functionApp']" | ConvertFrom-Json
$functionAppExists = $functionAppCheck.Length -gt 0
if (!$functionAppExists) {
    Write-Host "Function App does not exists. Creating..."
    # Create Azure Function App
    az functionapp create -g $resourceGroup -p $appServicePlan -n $functionApp  -s $storageAccount --os-type Windows --functions-version 3
    Write-Host "Function App created"
}
else {
    Write-Host $functionAppCheck.Length
    Write-Host $planCheck
}

