# Épicos e Histórias de Usuário - Gerador de Carrossel

## Épico 1: Infraestrutura Base e Autenticação

### E1-H1: Configuração Inicial do Projeto
Como desenvolvedor
Quero configurar a estrutura base do microsserviço
Para que possa iniciar o desenvolvimento com padrões estabelecidos

Critérios de Aceitação:
- [x] Projeto Spring Boot 3.3 configurado (Java 21)
- [x] Estrutura de pastas por domínio (api, application, domain, config)
- [x] Variáveis de ambiente básicas
- [x] Docker e docker-compose
- [x] CI/CD básico (ajustável futuramente)

DoD: Projeto rodando localmente com health check respondendo

---

### E1-H2: Integração com Keycloak
Como sistema
Quero validar tokens JWT do Keycloak
Para que apenas requisições autenticadas sejam processadas

Critérios de Aceitação:
- [x] Middleware de autenticação JWT implementado
- [x] Validação de realm `creator-platform`
- [x] Verificação de roles `ROLE_CREATOR` e `ROLE_SYSTEM`
- [x] Retorno 401 para tokens inválidos/ausentes
- [x] Extração de `usuarioId` do token

DoD: Endpoint protegido rejeita requisições sem token válido

---

### E1-H3: Configuração de Banco de Dados
Como sistema
Quero persistir logs e histórico de gerações
Para que possamos auditar e analisar o uso do serviço

Critérios de Aceitação:
- [x] PostgreSQL configurado e conectado
- [x] Migrations (Flyway) para tabela de logs
- [x] Entity/Model de CarouselLog implementado
- [x] Índices otimizados para auditoria
- [x] Pool de conexões (HikariCP) configurado

DoD: Sistema persiste logs no banco com sucesso

---

### E1-H4: Configuração de Cache Redis
Como sistema
Quero cachear templates e estilos
Para que a geração seja mais rápida e eficiente

Critérios de Aceitação:
- [x] Redis configurado e conectado
- [x] Estratégia de cache para tema/template por nicho/estilo
- [x] TTL configurável
- [x] Fallback quando Redis indisponível
- [x] Métricas de hit/miss/erro

DoD: Templates/tema são recuperados do cache quando disponíveis

---

## Épico 2: API Core - Geração de Carrossel Básica

### E2-H1: Endpoint POST /generate-carousel
Como orquestrador
Quero enviar texto base e parâmetros
Para que o serviço gere um carrossel estruturado

Critérios de Aceitação:
- [x] Endpoint POST /api/generate-carousel criado
- [x] Validação de payload (campos obrigatórios)
- [x] Response 200 com JSON definido
- [x] Response 400 para payload inválido; 422 para texto insuficiente
- [x] Header Authorization obrigatório e `X-Workflow-Id` no response

DoD: Endpoint recebe requisição e retorna estrutura básica

---

### E2-H2: Validação de Regras de Negócio
Como sistema
Quero validar os parâmetros recebidos
Para que apenas requisições válidas sejam processadas

Critérios de Aceitação:
- [x] R1: `quantidade` entre 1 e 50
- [x] R2: `baseText` mínimo de 300 caracteres
- [x] R4: `workflowId` presente, UUID válido e rastreável
- [x] Response 422 para texto insuficiente
- [x] Mensagens de erro descritivas por campo

DoD: Todas as validações implementadas e cobertas por handler

---

### E2-H3: Segmentação Semântica do Texto
Como sistema
Quero dividir o texto base em blocos lógicos
Para que cada bloco se torne um slide coerente

Critérios de Aceitação:
- [x] Blocos de 1–2 frases
- [x] Respeito a parágrafos e quebras lógicas
- [x] Preservação de contexto entre blocos curtos
- [x] Limite de 240 caracteres por slide
- [x] Tratamento de textos longos

DoD: Texto segmentado em blocos coerentes

---

### E2-H4: Geração Automática de Títulos
Como sistema
Quero gerar títulos curtos para cada slide
Para que o carrossel seja visualmente organizado

Critérios de Aceitação:
- [x] Extração de conceitos principais de cada bloco
- [x] Títulos com no máximo 8 palavras
- [x] Sem pontuação final em títulos
- [x] Evitar verbos fracos

DoD: Títulos gerados de forma consistente

---

## Épico 3: Tipos de Slides e Estrutura Narrativa

### E3-H1: Slide "intro"
Critérios de Aceitação:
- [x] Sempre primeiro slide; exatamente 1
- [x] Frase de impacto de até 8 palavras
- [x] Sem pontuação final
- [x] Layout `titulo_centralizado`

---

### E3-H2: Slide "contexto"
Critérios de Aceitação:
- [x] Extração dos 2 primeiros parágrafos
- [x] 1–2 frases curtas
- [x] Tom informativo
- [x] Posição 2ª (quando houver espaço)
- [x] Simplificação semântica aplicada

---

### E3-H3: Slide "insight"
Critérios de Aceitação:
- [x] Frases assertivas dos parágrafos centrais
- [x] Mínimo 40% do total de slides
- [x] Numeração quando mais de 3 insights
- [x] Frases de impacto priorizadas
- [x] Slides intermediários na sequência

---

### E3-H4: Slide "dado_apoio"
Critérios de Aceitação:
- [x] Detecção de padrões: "estudos mostram", "pesquisas indicam"
- [x] Extração de números e percentuais
- [x] Identificação opcional de autores de citações
- [x] Slide opcional
- [x] Formato: frase + destaque numérico

---

### E3-H5: Slide "exemplo_pratico"
Critérios de Aceitação:
- [x] Detecção de estruturas: "por exemplo", "como quando", "imagine que"
- [x] 1–2 frases simples
- [x] Posição após os insights
- [x] Opcional; clareza e aplicabilidade

---

### E3-H6: Slide "cta"
Critérios de Aceitação:
- [x] Sempre último slide; exatamente 1
- [x] Frases curtas e motivadoras
- [x] Templates por nicho disponíveis
- [x] Adicionado automaticamente se ausente

---

## Priorização Sugerida

Sprint 1–2: Foundation
- Épico 1: Infraestrutura Base (E1-H1 a E1-H4)
- Épico 2: API Core parcial (E2-H1, E2-H2, E2-H5)

Sprint 3–4: Core Features
- Épico 2: API Core completo (E2-H3, E2-H4)
- Épico 3: Tipos de Slides (E3-H1 a E3-H6)

Sprint 5–6: Visual & Styles
- Épico 4: Estilos e Personalização (E4-H1 a E4-H3)
- Épico 5: Tipos de Carrossel (E5-H1 a E5-H6)

Sprint 7–8: Observability & Quality
- Épico 6: Observabilidade (E6-H1 a E6-H4)
- Épico 7: Resiliência (E7-H1 a E7-H3)
- Épico 8: Testes (E8-H1 a E8-H3)

Sprint 9–10: AI Image Generation
- Épico 11: Geração de Imagens com IA (E11-H1 a E11-H10)

Sprint 11: Deploy & Documentation
- Épico 9: Documentação e Deploy (E9-H1 a E9-H3)

Backlog Futuro
- Épico 10: Melhorias Futuras (conforme demanda)

