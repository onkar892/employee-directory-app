#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Authenticating with Azure..."

az login --service-principal \
  --username "$AZURE_CLIENT_ID" \
  --password "$AZURE_CLIENT_SECRET" \
  --tenant "$AZURE_TENANT_ID"

echo "Deploying to Azure App Service..."

az webapp config container set \
  --name "$AZURE_APP_SERVICE" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --docker-custom-image-name "$DOCKER_IMAGE" \
  --docker-registry-server-url https://index.docker.io \
  --docker-registry-server-user "$DOCKER_USER" \
  --docker-registry-server-password "$DOCKER_PASS"

az webapp restart \
  --name "$AZURE_APP_SERVICE" \
  --resource-group "$AZURE_RESOURCE_GROUP"

echo "Deployment complete."