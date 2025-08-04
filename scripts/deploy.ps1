Write-Output "Authenticating with Azure..."

az login --service-principal `
    --username $env:AZURE_CLIENT_ID `
    --password $env:AZURE_CLIENT_SECRET `
    --tenant $env:AZURE_TENANT_ID | Out-Null

Write-Output "Checking if resource group exists..."
$exists = az group exists --name $env:AZURE_RESOURCE_GROUP | ConvertFrom-Json
if (-not $exists) {
    Write-Error "ERROR: Resource group '$env:AZURE_RESOURCE_GROUP' not found."
    exit 3
}

Write-Output "Deploying to Azure App Service..."

az webapp config container set `
    --name $env:AZURE_APP_SERVICE `
    --resource-group $env:AZURE_RESOURCE_GROUP `
    --container-image-name $env:DOCKER_IMAGE `
    --container-registry-url https://index.docker.io `
    --container-registry-user $env:DOCKER_USER `
    --container-registry-password $env:DOCKER_PASS

az webapp restart --name $env:AZURE_APP_SERVICE --resource-group $env:AZURE_RESOURCE_GROUP

Write-Output "Deployment complete."