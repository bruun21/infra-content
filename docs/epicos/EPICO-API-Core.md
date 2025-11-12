# Encerramento de Épico - API Core (Parcial)

> Período de Desenvolvimento: 30/10/2025 - 30/10/2025  
> Responsáveis: Agente Codex CLI  
> Contexto do Projeto: Gerador de Carrossel

---

## 1. Objetivo do Épico

Entregar o endpoint principal de geração de carrossel com validações de negócio, contrato OpenAPI e manutenibilidade.

---

## 2. Escopo Entregue

### 2.1 Funcionalidades
- [x] E2-H1: Endpoint `POST /api/generate-carousel` com autenticação e contrato claro.
- [x] E2-H2: Validações (UUID `workflowId`, `baseText` >= 300, `quantidade` 1..50) e `X-Workflow-Id` no response.
- [x] E2-H3: Segmentação semântica (1–2 frases, 240 caracteres, parágrafos).
- [x] E2-H4: Geração automática de títulos (conceitos, ≤ 8 palavras, sem pontuação, evita verbos fracos).
- [x] OpenAPI com esquema de segurança Bearer JWT e respostas tipadas.

### 2.2 Ajustes Técnicos
- [x] DTO `ValidationErrorResponse` e `GlobalExceptionHandler` com 400/422 conforme regra.

---

## 3. Decisões Técnicas

| Decisão | Motivo / Justificativa |
| :---- | :---- |
| Header `X-Workflow-Id` | Rastreabilidade ponta-a-ponta do fluxo |
| Regex para UUID (workflowId) | Validação forte do identificador |

---

## 4. Pendências / Próximas Etapas

| Tipo | Descrição | Responsável |
| :---- | :---- | :---- |
| Teste | Testes unitários/integração para validações e handler | - |

---

## 5. Contexto para o Próximo Épico

Prosseguir para Épico 3 (estrutura de slides), concluindo narrativa e composição. Itens E3-H1..H6 foram implementados e documentados em `EPICO-Tipos-de-Slides-e-Estrutura.md`.

---

## 6. Evidências

- Swagger UI: `http://localhost:8080/swagger-ui/index.html`
- OpenAPI: `http://localhost:8080/v3/api-docs`
