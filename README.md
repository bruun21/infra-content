# Infraestrutura - Content Platform

Este diretório contém a infraestrutura completa para rodar localmente todos os serviços da plataforma de geração de conteúdo.

## 📦 Componentes

### Infraestrutura Base
- **PostgreSQL 16** - Banco de dados compartilhado (schemas: `carousel`, `orchestrator`)
- **Redis 7** - Cache para carousel-service
- **MinIO** - Object storage (S3-compatible) para arquivos gerados
- **Keycloak 26** - Autenticação e autorização OAuth2/OIDC
- **Nginx** - Proxy reverso para MinIO

### Aplicações
- **base-generator** (porta 8089) - Gera conteúdo base usando OpenAI/Gemini
- **carousel-service** (porta 8080) - Gera carrosséis de slides
- **orchestrator** (porta 8082) - Orquestra as chamadas entre os serviços

## 🚀 Como Rodar

### 1. Configurar API Keys

```bash
# Copie o arquivo de exemplo
cp .env.example .env

# Edite o .env e adicione suas chaves
# OPENAI_API_KEY=sk-...
# GEMINI_API_KEY=...
```

### 2. Subir toda a stack

```bash
# Na pasta infra/
docker-compose up -d

# Acompanhar logs
docker-compose logs -f

# Verificar status
docker-compose ps
```

### 3. Acessar os serviços

| Serviço | URL | Credenciais |
|---------|-----|-------------|
| **Keycloak Admin** | http://localhost:8081 | admin / admin |
| **MinIO Console** | http://localhost:9001 | minioadmin / minioadmin |
| **Base Generator Swagger** | http://localhost:8089/swagger-ui.html | - |
| **Carousel Service Swagger** | http://localhost:8080/swagger-ui.html | - |
| **Orchestrator Swagger** | http://localhost:8082/swagger-ui.html | - |
| **PostgreSQL** | localhost:5432 | postgres / postgres |
| **Redis** | localhost:6379 | - |

### 4. Autenticação

O Keycloak está pré-configurado com:
- **Realm**: `creator-platform`
- **Client**: `api-client` (secret: `super-secret-123`)
- **Client**: `swagger-ui` (público, para testar no Swagger)
- **Usuário de teste**: `tester` / `tester`
- **Roles**: `CREATOR`, `SYSTEM`

## 🛠️ Comandos Úteis

```bash
# Reconstruir serviços após mudanças no código
docker-compose up -d --build base-generator
docker-compose up -d --build carousel-service
docker-compose up -d --build orchestrator

# Parar tudo
docker-compose down

# Parar e remover volumes (limpa banco de dados)
docker-compose down -v

# Logs de um serviço específico
docker-compose logs -f carousel-service

# Acessar shell de um container
docker-compose exec db psql -U postgres -d content_generator
docker-compose exec redis redis-cli
```

## 🗄️ Banco de Dados

O script `db/init/01_create_schemas.sql` cria automaticamente os schemas:
- `carousel` - usado pelo carousel-service
- `orchestrator` - usado pelo orchestrator

As tabelas são criadas automaticamente via JPA/Flyway na primeira execução.

## 📝 Documentação Adicional

- Regras de desenvolvimento: `Regras para desenvolvimento.md`
- Épicos implementados: `docs/epicos/`
- Setup do Keycloak: `docs/keycloak-setup.md`
- Changelog: `CHANGELOG.md`

## 🔧 Troubleshooting

### Serviço não inicia
```bash
# Verificar logs do serviço
docker-compose logs carousel-service

# Verificar se o Keycloak está healthy
docker-compose ps keycloak
```

### Erro de autenticação
```bash
# Verificar se o Keycloak está acessível
curl http://localhost:8081/realms/creator-platform/.well-known/openid-configuration

# Recriar o client se necessário
docker-compose restart keycloak-config
```

### Banco de dados não conecta
```bash
# Verificar se o Postgres está rodando
docker-compose ps db

# Acessar o banco manualmente
docker-compose exec db psql -U postgres -d content_generator -c "\dn"
```

## 📦 Deploy para Azure

Veja `../docs/azure-deployment.md` (a ser criado) para instruções de deploy na Azure usando:
- Azure Database for PostgreSQL
- Azure Cache for Redis
- Azure Blob Storage
- Azure Entra ID (Azure AD)
- Azure Container Apps
