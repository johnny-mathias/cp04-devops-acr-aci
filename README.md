# CP04 de Cloud & DevOps - ACR e ACI

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#cp04-de-cloud--devops---acr-e-aci)

Java repo: https://github.com/yJoaoVictor10/apiMovies-rm563409.git

MySQL repo: https://github.com/yJoaoVictor10/mysqlMovies-rm563409.git

---

#### 🖥️ VM

## 📦 1. Clonando os repositórios

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-1-clonando-os-reposit%C3%B3rios)

-- Clona os repositórios da API e do banco de dados

```bash
git clone https://github.com/yJoaoVictor10/apiMovies-rm563409.git
git clone https://github.com/yJoaoVictor10/mysqlMovies-rm563409.git
```

**svg**

---

#### 🖥️ VM

## 🐳 2. Criando as imagens Docker

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-2-criando-as-imagens-docker)

-- Acessa os projetos e cria as imagens Docker da aplicação e do MySQL

```bash
cd ./mysqlMovies-rm563409
docker build -f Dockerfile.mysql -t mysql-movies .

cd ../apiMovies-rm563409
docker build -f Dockerfile.api -t spring-movies .
```

**svg**

---

# ☁️ Deploy no Microsoft Azure

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#%EF%B8%8F-deploy-no-microsoft-azure)

#### ☁️ Azure CLI

## 🔐 3. Login no Azure

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-3-login-no-azure)

-- Realiza o login na conta do Azure

```bash
az login
```

**svg**

---

#### ☁️ Azure CLI

## 👤 4. Verificando a conta

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-4-verificando-a-conta)

-- Exibe os dados da conta e da assinatura ativa no Azure

```bash
az account show
```

**svg**

---

#### ☁️ Azure CLI

## 📁 5. Criando o Resource Group

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-5-criando-o-resource-group)

-- Cria o grupo de recursos no Azure na região especificada

```bash
az group create \
    --name acrspringrm563409 \
    --location chilecentral
```

**svg**

### Caso ocorra erro

```bash
az account list -o table
az account set --subscription <nome ou id>
```

**svg**

> ⚠️ **Atenção:** altere a localização (`--location`) conforme a política definida pelo professor.

---

# 📦 Azure Container Registry

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-azure-container-registry)

#### ☁️ Azure CLI

## 6. Registrando o Container Registry

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#6-registrando-o-azure-container-registry)

-- Registra o provedor do Azure Container Registry

```bash
az provider register --namespace Microsoft.ContainerRegistry
```

**svg**

---

#### ☁️ Azure CLI

## 7. Criando o Azure Container Registry

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#7-criando-o-azure-container-registry)

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

**svg**

> ⚠️ **Antes de executar:** confira o **RM**, o nome do Resource Group e a localização.

---

#### ☁️ Azure CLI

## 🔑 8. Obtendo as credenciais do Registry

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-8-obtendo-as-credenciais-do-registry)

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

**svg**

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

**svg**

---

#### 🖥️ VM

## 🔐 9. Login no Container Registry

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-9-login-no-container-registry)

-- Realiza o login no Azure Container Registry usando o Azure CLI e o Docker

```bash
az acr login --name acrspringrm563409

docker login acrspringrm563409.azurecr.io \
    -u $ADMIN_USERNAME \
    -p $ADMIN_PASSWORD
```

**svg**

---

# 🚀 Enviando as imagens para o Azure

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-enviando-as-imagens-para-o-azure)

#### 🖥️ VM

## 10. Verificando as imagens Docker

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#10-verificando-as-imagens-docker)

-- Lista as imagens Docker disponíveis localmente

```bash
docker image ls
```

**svg**

---

#### 🖥️ VM

## 11. Criando a tag da API

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#11-criando-a-tag-da-api)

-- Adiciona uma tag à imagem da API para prepará-la para o envio ao registry

```bash
docker tag spring-movies \
    acrspringrm563409.azurecr.io/spring-movies:v1
```

**svg**

---

#### 🖥️ VM

## 12. Enviando a API para o Registry

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#12-enviando-a-api-para-o-registry)

-- Envia a imagem da API para o Azure Container Registry

```bash
docker push acrspringrm563409.azurecr.io/spring-movies:v1
```

**svg**

---

#### 🖥️ VM

## 13. Enviando o MySQL para o Registry

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#13-enviando-o-mysql-para-o-registry)

-- Adiciona uma tag à imagem do MySQL e envia a imagem para o registry

```bash
docker tag mysql-movies \
    acrspringrm563409.azurecr.io/mysql-movies:v1

docker push acrspringrm563409.azurecr.io/mysql-movies:v1
```

**svg**

---

#### ☁️ Azure CLI

## 14. Verificando os repositórios

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#14-verificando-os-reposit%C3%B3rios)

-- Lista os repositórios de imagens armazenados no Azure Container Registry

```bash
az acr repository list \
    --name acrspringrm563409 \
    --output table
```

**svg**

---

#### 🖥️ VM

## 🧹 15. Removendo as imagens locais

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-15-removendo-as-imagens-locais)

-- Remove as imagens do registry da máquina local

```bash
docker rmi acrspringrm563409.azurecr.io/spring-movies:v1
docker rmi acrspringrm563409.azurecr.io/mysql-movies:v1
```

**svg**

---

# 🗄️ Configuração do MySQL

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#%EF%B8%8F-configura%C3%A7%C3%A3o-do-mysql)

#### 🖥️ VM

## 16. Criando o Storage Account

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#16-criando-o-storage-account)

-- Torna o script executável e executa a configuração do Storage Account

```bash
chmod +x 01_store-account.sh
./01_store-account.sh > 01_store-account.log
```

**svg**

---

#### 🖥️ VM

## 🔐 17. Configurando o Azure Key Vault

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-17-configurando-o-azure-key-vault)

-- Torna o script executável e executa a configuração do Azure Key Vault

```bash
chmod +x 02_key-vault.sh
./02_key-vault.sh > 02_key-vault.log
```

**svg**

---

#### 🖥️ VM

## 🐬 18. Criando o container MySQL

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-18-criando-o-container-mysql)

-- Torna o script executável e cria o container do MySQL no Azure Container Instances

```bash
chmod +x 03_aci-mysql.sh
./03_aci-mysql.sh > 03_aci-mysql.log
```

**svg**

---

#### ☁️ Azure CLI

## 🔎 19. Acessando o MySQL

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-19-acessando-o-mysql)

-- Acessa o MySQL no container e consulta os filmes armazenados no banco

```bash
az container exec \
    --resource-group rg-movies-rm563409 \
    --name mysql-movies \
    --exec-command "mysql -u user-movies -psenha-movies"
```

**svg**

-- Seleciona o banco de dados de filmes

```sql
use db-movies;
```

**svg**

-- Lista todos os filmes cadastrados

```sql
select * from movie;
```

**svg**

---

# ☕ Deploy da API Java

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-deploy-da-api-java)

#### 🖥️ VM

## 20. Criando o container da API

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#20-criando-o-container-da-api)

-- Torna o script executável e cria o container da API Java no Azure

```bash
chmod +x 04_aci-api-java.sh
./04_aci-api-java.sh > 04_aci-api-java.log
```

**svg**

---

#### ☁️ Azure CLI

## 📋 21. Visualizando os logs

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-21-visualizando-os-logs)

-- Exibe os logs do container da API Java

```bash
az container logs \
    --resource-group rg-movies-rm563409 \
    --name api-java
```

**svg**

---

#### ☁️ Azure CLI

## 💻 22. Acessando o container da API

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-22-acessando-o-container-da-api)

-- Abre um terminal Bash dentro do container da API Java

```bash
az container exec \
    --resource-group rg-movies-rm563409 \
    --name api-java \
    --exec-command "/bin/bash"
```

**svg**

---

# 🔌 Testando a API

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-testando-a-api)

#### 📦 Container da API

## GET — Listar filmes

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#get--listar-filmes)

-- Consulta todos os filmes através da API

```bash
curl -X GET http://localhost:8080/movies
```

**svg**

---

#### 📦 Container da API

## POST — Cadastrar filme

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#post--cadastrar-filme)

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

**svg**

---

#### 📦 Container da API

## PUT — Atualizar filme

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#put--atualizar-filme)

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

**svg**

---

#### 📦 Container da API

## DELETE — Excluir filme

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#delete--excluir-filme)

-- Exclui um filme através da API

```bash
curl -X DELETE http://localhost:8080/movies/5
```

**svg**

---

# 📌 Resumo do fluxo

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#-resumo-do-fluxo)

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

**svg**

## ⚠️ Observações importantes

[svg](https://github.com/johnny-mathias/cp04-devops-acr-aci/#%EF%B8%8F-observa%C3%A7%C3%B5es-importantes)

* Substitua `rm563409` pelo seu RM quando necessário.
* Verifique o **Resource Group** utilizado antes de executar os comandos.
* Ajuste a região (`--location`) conforme a localização do seu datacenter.
* Confira os nomes dos containers antes de executar comandos `az container`.
* Os comandos `curl` devem ser executados no ambiente onde a API está acessível.
* Evite compartilhar publicamente as credenciais do Azure Container Registry.
