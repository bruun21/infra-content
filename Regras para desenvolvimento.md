# Regras para Desenvolvimento

Este documento define as diretrizes oficiais para o desenvolvimento de microsserviços e sistemas da Defensoria. Objetivo: garantir padronização, legibilidade, escalabilidade e rastreabilidade.

1. Plataforma e Linguagem Padrão (Java 21 LTS)
- Plataforma padrão: todos os serviços (exceto Keycloak, que segue sua própria stack e ciclos) devem usar Java 21 LTS e framework compatível (ex.: Spring Boot 3.2+ ou Quarkus 3.x+).
- Justificativa: Java 21 é LTS, com melhorias de desempenho, segurança e Virtual Threads (Project Loom).

2. Comunicação e Resiliência (Assíncrona e Não Bloqueante)
- Priorizar arquitetura reativa/não bloqueante para endpoints HTTP e comunicação entre serviços quando fizer sentido de negócio.
- Recomenda-se usar Virtual Threads do Java 21 para endpoints síncronos de alta concorrência.
- Justificativa: maximiza escalabilidade/eficiência sem complexidade excessiva.

3. Documentação e Contrato de API
- Todos os serviços que expõem HTTP devem implementar OpenAPI 3.x (Swagger) com geração por anotações, cobrindo: parâmetros e schemas, códigos de resposta (incluindo erros) e mecanismos de segurança.
- Justificativa: contrato preciso, interativo e atualizado para consumo interno/externo.

4. Segurança e Autenticação (Keycloak / OAuth 2.0)
- Autenticação/Autorização centralizadas: endpoints protegidos por JWT emitido/validado pelo Keycloak, seguindo OAuth 2.0 / OIDC.
- Verificar permissões por endpoint crítico via scopes/roles no token.
- Justificativa: segurança moderna centralizada, controle de acesso efetivo.

5. Ciclo de Desenvolvimento de Épicos (Documentação e Contexto)
- Pós-épico: criar/atualizar arquivo .md descrevendo entregas, decisões técnicas, pendências e contexto da próxima etapa.
- Pré-épico: revisar a documentação dos épicos anteriores e cruzar contexto (entregue, pendente, ajustes).
- Higienização: remover código/artefatos de teste fora do escopo antes do merge final.
- Clean Code: legibilidade, simplicidade, coesão; evitar duplicações, comentários desnecessários e funções longas. Usar lint/análise estática (SonarLint, Checkstyle, SpotBugs).

