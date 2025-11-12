# Microserviço: Gerador de Carrossel

Este repositório contém as diretrizes, épicos e a implementação do microsserviço de geração de carrosséis, seguindo as Regras para Desenvolvimento.

- Regras: `Regras para desenvolvimento.md`
- Épicos/Histórias: `carousel_epics_stories.md`
  - Encerramentos:
    - `docs/epicos/EPICO-Infra-e-Autenticacao.md`
    - `docs/epicos/EPICO-API-Core.md`
    - `docs/epicos/EPICO-Tipos-de-Slides-e-Estrutura.md`
- Template de encerramento de épico: `epico_template.md`
- Serviço (Java 21 + Spring Boot 3.3): `carousel-service/`
 - Changelog: `CHANGELOG.md`

## Como rodar

Veja `carousel-service/README.md` para build, execução e uso do endpoint `POST /api/generate-carousel`.

## Próximos épicos sugeridos

- E1-H2: Integração Keycloak com realm/roles reais e testes.
- E1-H3/H4: Postgres + Redis com cache de templates e logs estruturados.
- E6: Métricas Prometheus/Grafana e correlação por `workflowId`.
