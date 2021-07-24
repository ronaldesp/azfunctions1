#powershell.exe .\PowerShellScripts\CreateAzFuncDNSUpdate.ps1 -ResourceGroupName 'rg-OPS-functions-cace1' -LocationName 'canadacentral1'
#powershell.exe -Command .\PowerShellScripts\CreateAzFuncDNSUpdate.ps1 'rg-OPS-functions-cace1' 'canadacentral1'
.\PowerShellScripts\CreateAzFuncDNSUpdate.ps1 -ResourceGroupName 'rg-OPS-functions-cace1' -LocationName 'canadacentral1'

.\PowerShellScripts\CreateAzFuncDNSUpdate.ps1 -ResourceGroupName 'rgfunctions' -LocationName 'eastus' -storageAccountName 'storageaccountazf' -appServicePlanName 'ASP-rgfunctions-ad5e' -functionAppName 'azf1'
