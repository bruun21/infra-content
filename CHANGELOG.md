# Changelog

Todas as mudanças notáveis neste repositório.

## 2025-10-30

- Épico 1 (Infra + Autenticação)
  - E1-H2: Integração Keycloak (JWT Bearer, validação de realm `creator-platform`, roles `ROLE_CREATOR|ROLE_SYSTEM`, extração de `usuarioId`).
  - E1-H3: PostgreSQL com Flyway (tabela `carousel_log`, índices, HikariCP, `ddl-auto=validate`).
  - E1-H4: Redis para cache de tema/template por nicho/estilo com TTL e métricas (`carousel_template_cache_*`).

- Épico 2 (API Core)
  - E2-H1: Endpoint `POST /api/generate-carousel` com segurança e header `X-Workflow-Id`.
  - E2-H2: Validações de negócio (UUID `workflowId`, `baseText` ≥ 300, `quantidade` 1..50) e handler 400/422 tipado.
  - E2-H3: Segmentação semântica (1–2 frases, 240 caracteres, sensível a parágrafos).
  - E2-H4: Geração de títulos (conceitos, ≤ 8 palavras, sem pontuação, evita verbos fracos).

- Épico 3 (Tipos de Slides e Estrutura)
  - E3-H1..H6: `intro`, `contexto`, `insight` (≥ 40% e numeração >3), `dado_apoio` (destaque numérico), `exemplo_pratico`, `cta` (sempre último).

- Épico 4 (Estilos e Personalização)
  - E4-H1: Overrides de tema visual no request (`temaVisual`) com cache por `nicho/estilo`.
  - E4-H2: Overrides de layout por tipo de slide (`layouts`) aplicados na geração.
  - E4-H3: Temas padrão por nicho/estilo com fallback e armazenamento em cache.

- Documentação
  - OpenAPI: esquema Bearer JWT global e respostas tipadas.
  - Docs de épicos: `docs/epicos/EPICO-Infra-e-Autenticacao.md`, `docs/epicos/EPICO-API-Core.md`, `docs/epicos/EPICO-Tipos-de-Slides-e-Estrutura.md`, `docs/epicos/EPICO-Estilos-e-Personalizacao.md`.
  - `carousel_epics_stories.md` normalizado (UTF-8) e atualizado.
  - READMEs revisados (serviço e raiz) com instruções e observações de execução.

- Observações de execução
  - Necessita Postgres acessível (ou `docker compose up`) devido a `ddl-auto=validate`.
  - Prometheus exposto em `/actuator/prometheus`.

- Arquivos principais impactados
  - Segurança: `carousel-service/src/main/java/br/defensoria/carousel/config/SecurityConfig.java`
  - OpenAPI: `carousel-service/src/main/java/br/defensoria/carousel/config/OpenApiConfig.java`
  - Controller/API: `carousel-service/src/main/java/br/defensoria/carousel/api/*`
  - Serviço: `carousel-service/src/main/java/br/defensoria/carousel/application/CarouselGeneratorService.java`, `TemplateCacheService.java`
  - Domínio/DB: `carousel-service/src/main/java/br/defensoria/carousel/domain/*`, `src/main/resources/db/migration/V1__create_carousel_log.sql`
  - Config: `carousel-service/src/main/resources/application.yml`, `pom.xml`
