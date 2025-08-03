#!/bin/bash

# Azure login using Service Principal
echo "Authenticating with Azure..." 

az login --service-principal \
  --username "$client_id" \
  --password "$client_secret" \
  --tenant "$tenant_id"


echo "deploying to azure app service......"

az webapp config container set \
  --name $app_service_name \
  --resource-group $resource_group \
  --docker-custom-image-name $docker_image \
  --docker-registry-server-url https://index.docker.io \
  --docker-registry-server-user <your-dockerhub-username> \
  --docker-registry-server-password <your-dockerhub-password>

az webapp restart --name $APP_SERVICE_NAME --resource-group $RESOURCE_GROUP

echo "Deployment complete."