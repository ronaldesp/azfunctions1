[CmdletBinding()]
param (
    $ResourceGroupName='rgfunctions',
    $LocationName='eastus',
    $storageAccountName='storageaccountazf',
    $appServicePlanName='planazf',
    $functionAppName='azf11'
)

    # $ResourceGroupName='rg-OPS-functions-cace',
    # $LocationName='canadacentral',
    # $storageAccountName='devopsstoragefunctions2',
    # $appServicePlanName='plan-WinApp-Ops-Functions-cace',
    # $functionAppName='func-Ops-cf-dns-update02-cace'

# az login
# az account set --subscription "a74522a1-9e20-48ba-8edd-afd9172ec929"
# az account list --output table

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

$resourceCheck = az group exists --name $resourceGroup
if ($resourceCheck = "false")
{
    Write-Host "Resource group does not exists. Creating..."
    # Create a Resource Group
    az group create -n $resourceGroup -l $location # --subscription 
    Write-Host "Resource group created"
}
else {
    Write-Host "Resource group already exists"
}

$storageCheck = az storage account list --query "[?name=='$storageAccount']" | ConvertFrom-Json
$storageExists = $storageCheck.Length -gt 0
if (!$storageExists)
{
    Write-Host "Storage Account does not exists. Creating..."
    # Create Storage Account
    az storage account create -n $storageAccount -l $location -g $resourceGroup --sku Standard_LRS
    Write-Host "Storage Account created"
}
else {
    Write-Host "Storage Account already exists"
}


$planCheck = az appservice plan list --query "[?name=='$appServicePlan']" | ConvertFrom-Json
$planExists = $planCheck.Length -gt 0
if (!$planExists) {
    Write-Host "App Service Plan does not exists. Creating..."
    # To create an App service plan
    az appservice plan create -g $resourceGroup -n $appServicePlan --sku S1
    Write-Host "App Service Plan created"
}
else {
    Write-Host $planCheck.Length
    Write-Host $planCheck
    Write-Host "App Service Plan already exists"
}

# $functionAppCheck = az functionapp function show -g $resourceGroup -n 'funcre' --function-name $functionApp | ConvertFrom-Json
# $functionAppCheck = az functionapp function show -g $resourceGroup -n 'funcre' --function-name 'noexiste' | ConvertFrom-Json

# $functionAppCheck = az functionapp list --query "[].{Name: name,Group: resourceGroup}" #"[?name=='$functionApp']" | ConvertFrom-Json
# Write-Host $functionAppCheck

$functionAppCheck = az functionapp list --query "[?name=='$functionApp']" | ConvertFrom-Json
Write-Host $functionAppCheck
$functionAppExists = $functionAppCheck.Length -gt 0
if (!$functionAppExists) {
    Write-Host "Function App does not exists. Creating..."
    Write-Host $functionAppCheck.Length
    Write-Host $functionAppCheck
    # Create Azure Function App
    az functionapp create -g $resourceGroup -p $appServicePlan -n $functionApp  -s $storageAccount --os-type Windows --functions-version 3 # --debug
    Write-Host "Function App created"
}
else {
    Write-Host $functionAppCheck.Length
    Write-Host $functionAppCheck
}

