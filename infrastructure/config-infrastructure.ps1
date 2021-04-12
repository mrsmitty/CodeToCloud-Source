param (
    [Parameter()] [string] $ghpat
)
$studentprefix = "346713"
$resourcegroupName = "fabmedical-rg-" + $studentprefix
$cosmosDBName = "fabmedical-cdb-" + $studentprefix
$webappName = "fabmedical-web-" + $studentprefix

$cnString = $(az cosmosdb keys list `
    -n $cosmosDBName `
    -g $resourceGroupName `
    --type connection-strings `
    --query "connectionStrings[0].connectionString" -o tsv)

$cnString = $cnString -replace "10255/", "10255/contentdb"

az webapp config appsettings set -n $webappName `
    -g $resourcegroupName `
    --settings MONGODB_CONNECTION="$cnString"

az webapp config container set `
    --docker-registry-server-password $ghPat `
    --docker-registry-server-url https://ghcr.io `
    --docker-registry-server-user USERNAME `
    --multicontainer-config-file docker-compose.yml `
    --multicontainer-config-type COMPOSE `
    --name $webappName `
    --resource-group $resourcegroupName
