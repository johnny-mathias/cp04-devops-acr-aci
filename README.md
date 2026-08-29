# CP04 de Cloud & DevOps - ACR e ACI



Java repo: https://github.com/yJoaoVictor10/apiMovies-rm563409.git

MySQL repo: https://github.com/yJoaoVictor10/mysqlMovies-rm563409.git

---

#### 🖥️ VM

## 📦 1. Clonando os repositórios


-- Clona os repositórios da API e do banco de dados

```bash
git clone https://github.com/yJoaoVictor10/apiMovies-rm563409.git
git clone https://github.com/yJoaoVictor10/mysqlMovies-rm563409.git
```


---

#### 🖥️ VM

## 🐳 2. Criando as imagens Docker


-- Acessa os projetos e cria as imagens Docker da aplicação e do MySQL

```bash
cd ./mysqlMovies-rm563409
docker build -f Dockerfile.mysql -t mysql-movies .

cd ../apiMovies-rm563409
docker build -f Dockerfile.api -t spring-movies .
```


---

# ☁️ Deploy no Microsoft Azure


#### 🖥️ VM

## 🔐 3. Login no Azure


-- Realiza o login na conta do Azure

```bash
az login
```


---

#### 🖥️ VM

## 👤 4. Verificando a conta


-- Exibe os dados da conta e da assinatura ativa no Azure

```bash
az account show
```


---

#### 🖥️ VM

## 📁 5. Criando o Resource Group


-- Cria o grupo de recursos no Azure na região especificada

```bash
az group create \
    --name rg-movies-rm563409 \
    --location chilecentral
```


### Caso ocorra erro

```bash
az account list -o table
az account set --subscription <nome ou id>
```


> ⚠️ **Atenção:** altere a localização (`--location`) conforme a política definida pelo professor.

---

# 📦 Azure Container Registry


#### 🖥️ VM

## 6. Registrando o Container Registry


-- Registra o provedor do Azure Container Registry

```bash
az provider register --namespace Microsoft.ContainerRegistry
```


---

#### 🖥️ VM

## 7. Criando o Azure Container Registry


-- Cria um Azure Container Registry para armazenar as imagens Docker

```bash
az acr create \
    --resource-group rg-movies-rm563409 \
    --name acrspringrm563409 \
    --sku Standard \
    --location chilecentral \
    --public-network-enabled true \
    --admin-enabled true
```


> ⚠️ **Antes de executar:** confira o **RM**, o nome do Resource Group e a localização.

---

#### 🖥️ VM

## 🔑 8. Obtendo as credenciais do Registry


-- Obtém e exibe o endereço de acesso ao Azure Container Registry

```bash
LOGIN_SERVER=$(az acr show \
    --name acrspringrm563409 \
    --resource-group rg-movies-rm563409 \
    --query loginServer \
    --output tsv)

echo ""
echo "Login Server: $LOGIN_SERVER"
echo ""
```


-- Obtém e exibe as credenciais administrativas do Azure Container Registry

```bash
ADMIN_USERNAME=$(az acr credential show \
    --name acrspringrm563409 \
    --resource-group rg-movies-rm563409 \
    --query username \
    --output tsv) && \

ADMIN_PASSWORD=$(az acr credential show \
    --name acrspringrm563409 \
    --resource-group rg-movies-rm563409 \
    --query passwords[0].value \
    --output tsv) && \

echo "Username: $ADMIN_USERNAME" && \
echo "Password: $ADMIN_PASSWORD"
```


---

#### 🖥️ VM

## 🔐 9. Login no Container Registry


-- Realiza o login no Azure Container Registry usando o Azure CLI e o Docker

```bash
az acr login --name acrspringrm563409

docker login acrspringrm563409.azurecr.io \
    -u $ADMIN_USERNAME \
    -p $ADMIN_PASSWORD
```


---

# 🚀 Enviando as imagens para o Azure


#### 🖥️ VM

## 10. Verificando as imagens Docker


-- Lista as imagens Docker disponíveis localmente

```bash
docker image ls
```


---

#### 🖥️ VM

## 11. Criando a tag da API


-- Adiciona uma tag à imagem da API para prepará-la para o envio ao registry

```bash
docker tag spring-movies \
    acrspringrm563409.azurecr.io/spring-movies:v1
```


---

#### 🖥️ VM

## 12. Enviando a API para o Registry


-- Envia a imagem da API para o Azure Container Registry

```bash
docker push acrspringrm563409.azurecr.io/spring-movies:v1
```


---

#### 🖥️ VM

## 13. Enviando o MySQL para o Registry


-- Adiciona uma tag à imagem do MySQL e envia a imagem para o registry

```bash
docker tag mysql-movies \
    acrspringrm563409.azurecr.io/mysql-movies:v1

docker push acrspringrm563409.azurecr.io/mysql-movies:v1
```


---

#### 🖥️ VM

## 14. Verificando os repositórios


-- Lista os repositórios de imagens armazenados no Azure Container Registry

```bash
az acr repository list \
    --name acrspringrm563409 \
    --output table
```


---

#### 🖥️ VM

## 🧹 15. Removendo as imagens locais


-- Remove as imagens do registry da máquina local

```bash
docker rmi acrspringrm563409.azurecr.io/spring-movies:v1
docker rmi acrspringrm563409.azurecr.io/mysql-movies:v1
```


E para o passo a seguir saia da VM:

## ☁️ Saia da VM:
```bash
exit
```


---

# 🗄️ Configuração do MySQL


#### ☁️ Azure CLI

## 16. Criando o Storage Account


-- Torna o script executável e executa a configuração do Storage Account

```bash
chmod +x 01_store-account.sh
./01_store-account.sh 
```


---

#### ☁️ Azure CLI

## 🔐 17. Configurando o Azure Key Vault


-- Torna o script executável e executa a configuração do Azure Key Vault

```bash
chmod +x 02_key-vault.sh
./02_key-vault.sh 
```

---

#### ☁️ Azure CLI

## 🐬 18. Criando o container MySQL


-- Torna o script executável e cria o container do MySQL no Azure Container Instances

```bash
chmod +x 03_aci-mysql.sh
./03_aci-mysql.sh
```


---

#### 🖥️ VM

## 🔎 19. Acessando o MySQL


-- Acessa o MySQL no container e consulta os filmes armazenados no banco

```bash
az container exec \
    --resource-group rg-movies-rm563409 \
    --name rm563409-mysql-movies \
    --exec-command "mysql -u user-movies -psenha-movies"
```


-- Seleciona o banco de dados de filmes

```sql
use db-movies;
```


-- Lista todos os filmes cadastrados

```sql
select * from movie;
```


---

# ☕ Deploy da API Java


#### ☁️ Azure CLI

## 20. Criando o container da API


-- Torna o script executável e cria o container da API Java no Azure

```bash
chmod +x 04_aci-api-java.sh
./04_aci-api-java.sh 
```


---

#### 🖥️ VM

## 📋 21. Visualizando os logs


-- Exibe os logs do container da API Java

```bash
az container logs \
    --resource-group rg-movies-rm563409 \
    --name api-java
```


---

#### 🖥️ VM

## 💻 22. Acessando o container da API


-- Abre um terminal Bash dentro do container da API Java

```bash
az container exec \
    --resource-group rg-movies-rm563409 \
    --name rm563409-api-java \
    --exec-command "/bin/bash"
```


---

# 🔌 Testando a API


#### 📦 Container da API

## GET — Listar filmes


-- Consulta todos os filmes através da API

```bash
curl -X GET http://localhost:8080/movies
```


---

#### 📦 Container da API

## POST — Cadastrar filme


-- Cadastra um novo filme através da API

```bash
curl -X POST http://localhost:8080/movies \
-H "Content-Type: application/json" \
-d '{
  "rating": 9,
  "releaseDate": "2010-07-16",
  "synopsis": "Um ladrão especializado em invadir sonhos recebe a missão de implantar uma ideia na mente de um empresário.",
  "title": "A Origem"
}'
```


---

#### 📦 Container da API

## PUT — Atualizar filme


-- Atualiza os dados de um filme existente através da API

```bash
curl -X PUT http://localhost:8080/movies/5 \
-H "Content-Type: application/json" \
-d '{
  "rating": 10,
  "releaseDate": "1972-03-24",
  "synopsis": "A história de uma poderosa família envolvida no mundo do crime organizado.",
  "title": "O Poderoso Chefão - Edição Especial"
}'
```


---

#### 📦 Container da API

## DELETE — Excluir filme


-- Exclui um filme através da API

```bash
curl -X DELETE http://localhost:8080/movies/5
```


---

# 📌 Resumo do fluxo


```text
Repositórios Git
       │
       ▼
   Docker Build
       │
       ├──────────────┐
       ▼              ▼
 Spring Movies     MySQL Movies
       │              │
       └──────┬───────┘
              ▼
    Azure Container Registry
              │
              ▼
     Azure Container Instances
              │
       ┌──────┴──────┐
       ▼             ▼
   API Java        MySQL
       │
       ▼
   REST API
       │
       ▼
  GET / POST / PUT / DELETE
```


## ⚠️ Observações importantes


* Substitua `rm563409` pelo seu RM quando necessário.
* Verifique o **Resource Group** utilizado antes de executar os comandos.
* Ajuste a região (`--location`) conforme a localização do seu datacenter.
* Confira os nomes dos containers antes de executar comandos `az container`.
* Os comandos `curl` devem ser executados no ambiente onde a API está acessível.
* Evite compartilhar publicamente as credenciais do Azure Container Registry.
