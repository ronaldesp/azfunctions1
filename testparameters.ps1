[CmdletBinding()]
param (
    $ResourceGroupName,
    $LocationName
)

$resourceGroup = $ResourceGroupName
$location = $LocationName

Write-Host $resourceGroup
Write-Host $location
