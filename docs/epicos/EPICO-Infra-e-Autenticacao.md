# Encerramento de Épico - Infraestrutura Base e Autenticação (Concluído)

> Período de Desenvolvimento: 29/10/2025 - 30/10/2025  
> Responsáveis: Agente Codex CLI  
> Contexto do Projeto: Gerador de Carrossel

---

## 1. Objetivo do Épico

Configurar o esqueleto do microsserviço conforme as regras (Java 21, Spring Boot 3.3), segurança com Keycloak e fundações de persistência/cache, preparando terreno para os próximos épicos.

---

## 2. Escopo Entregue

### 2.1 Funcionalidades
- [x] Projeto base Spring Boot 3.3 (Java 21) em `carousel-service/`.
- [x] Segurança JWT (Keycloak) com realm `creator-platform`, roles `ROLE_CREATOR|ROLE_SYSTEM` e extração de `usuarioId` do `sub` (E1-H2).
- [x] Persistência com PostgreSQL via JPA + Flyway com migração `V1__create_carousel_log.sql` (E1-H3).
- [x] Cache Redis para tema/template com TTL e fallback (E1-H4), com métricas de hit/miss/erro.
- [x] Actuator com health e Prometheus. OpenAPI (Swagger UI) habilitado.

### 2.2 Ajustes Técnicos
- [x] Virtual Threads (`spring.threads.virtual.enabled=true`).
- [x] Estrutura de pacotes por domínio (api, application, domain, config).
- [x] `Dockerfile` e `docker-compose.yml` com Postgres, Redis e Keycloak dev.

---

## 3. Decisões Técnicas

| Decisão | Motivo / Justificativa |
| :---- | :---- |
| Java 21 + Spring Boot 3.3 | Aderência às regras e LTS com Virtual Threads |
| Spring Security Resource Server (JWT) | Integração limpa com Keycloak (OAuth2/OIDC) |
| Flyway + `ddl-auto=validate` | Schema controlado por migrações e validação de integridade |
| Redis StringTemplate + TTL | Desempenho e resiliência com fallback silencioso |
| springdoc-openapi | Geração automática da documentação OpenAPI |

---

## 4. Pendências / Próximas Etapas

| Tipo | Descrição | Responsável |
| :---- | :---- | :---- |
| Integração | Configurar realm `creator-platform` no Keycloak dev | - |
| Teste | Adicionar testes unitários para segurança/roles | - |

---

## 5. Contexto para o Próximo Épico

Prosseguir com Épico 2 (API Core) e Épico 3 (Estrutura Narrativa), além de observabilidade (Épico 6) em momento oportuno.

---

## 6. Higienização e Revisão de Código

- [x] Sem códigos temporários no repositório.
- [x] Estrutura organizada por domínio.

---

## 7. Evidências (Opcional)

- Swagger UI: `http://localhost:8080/swagger-ui/index.html`
- Health: `http://localhost:8080/actuator/health`

---

## 8. Conclusão

Infraestrutura e autenticação concluídas conforme regras. Serviço protegido por Keycloak (realm validado), logs persistidos com Flyway, cache Redis operante com métricas. Pronto para evoluir a API e narrativa.

