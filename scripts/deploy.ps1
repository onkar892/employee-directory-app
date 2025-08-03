# deploy.ps1

Write-Output "Authenticating with Azure..."

# Login using service principal credentials passed as environment variables
az login --service-principal `
    --username $env:AZURE_CLIENT_ID `
    --password $env:AZURE_CLIENT_SECRET `
    --tenant $env:AZURE_TENANT_ID

Write-Output "Deploying to Azure App Service..."

az webapp config container set `
    --name $env:AZURE_APP_SERVICE `
    --resource-group $env:AZURE_RESOURCE_GROUP `
    --docker-custom-image-name $env:DOCKER_IMAGE `
    --docker-registry-server-url https://index.docker.io `
    --docker-registry-server-user $env:DOCKER_USER `
    --docker-registry-server-password $env:DOCKER_PASS

az webapp restart --name $env:AZURE_APP_SERVICE --resource-group $env:AZURE_RESOURCE_GROUP

Write-Output "Deployment complete."