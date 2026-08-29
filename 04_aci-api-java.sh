# Variáveis
# ALTERE PARA SEU RM E SUA REGIÃO (Política)
rm=rm563409
location="chilecentral"
resourceGroup="rg-movies-rm563409"
acrName="acrspring$rm"
aciName="api-java"
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

# O comando sed troca a palavra mysql-dimdim para o IP Público do ACI em runtime (Somente Linux)
#
# Outro exemplo do comando sed:
# echo "My name is Bond, James Bond" | sed "s/Bond/Stuart/g"
#
# Em Power Shell
# 'My name is Bond, James Bond' -replace 'Bond', 'Stuart'
#

# Testes após a criação
#
#fqdnJava=$(az container show --resource-group rg-money-hub --name api-java --query ipAddress.fqdn --output tsv)

#curl -X GET http://$fqdnJava:8080/api/transacoes

#curl -X POST http://$fqdnJava:8080/api/transacoes \
#  -H "Content-Type: application/json" \
#  -d '{
#    "descricao": "Compra no supermercado",
#    "valor": 150.75
#  }'

#curl -X PUT http://$fqdnJava:8080/api/transacoes/6 \
#  -H "Content-Type: application/json" \
#  -d '{
#    "descricao": "Compra no supermercado - ALTERADO",
#    "valor": 150.76,
#    "dataTransacao": "2024-06-18T00:00:00"
#  }'

#curl -X DELETE http://$fqdnJava:8080/api/transacoes/6
