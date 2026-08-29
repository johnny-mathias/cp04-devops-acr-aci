# Variáveis
# ALTERE PARA SEU RM E SUA REGIÃO (Política)
rm=rm563409
location="chilecentral"
resourceGroup="rg-movies-rm563409"
acrName="acrspring$rm"
aciName="rm563409-api-java"
aciNameMysql="mysql-movies"
imageName="spring-movies"
tag="v1"
keyVaultName="keyvault-$rm"
mysqlURL=$(az container show --resource-group $resourceGroup --name $aciNameMysql --query ipAddress.fqdn --output tsv)
# Registra o Serviço de ACI na Assintaura
az provider register --namespace Microsoft.ContainerInstance
# Deploy do Container Api de Java
az container create \
  --resource-group $resourceGroup \
  --name $aciName \
  --location $location \
  --image $acrName.azurecr.io/$imageName:$tag \
  --cpu 1 \
  --memory 1 \
  --os-type Linux \
  --dns-name-label api-java-$rm \
  --ports 8080 \
  --registry-login-server $acrName.azurecr.io \
  --registry-username $(az keyvault secret show --vault-name $keyVaultName --name acr-username --query value -o tsv) \
  --registry-password $(az keyvault secret show --vault-name $keyVaultName --name acr-password --query value -o tsv) \
  --environment-variables \
    SPRING_DATASOURCE_URL=$(az keyvault secret show --name spring-datasource-url --vault-name $keyVaultName --query value -o tsv | sed "s/mysql-dimdim/$mysqlURL/") \
    SPRING_DATASOURCE_USERNAME=$(az keyvault secret show --name spring-datasource-username --vault-name $keyVaultName --query value -o tsv) \
    SPRING_DATASOURCE_PASSWORD=$(az keyvault secret show --name spring-datasource-password --vault-name $keyVaultName --query value -o tsv) \
  --restart-policy Always
