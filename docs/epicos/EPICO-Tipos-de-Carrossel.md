# Encerramento de épico - Tipos de Carrossel (Concluído)

> Período de Desenvolvimento: 30/10/2025  
> Responsáveis: Agente Codex CLI  
> Contexto do Projeto: Gerador de Carrossel

---

## 1. Objetivo do épico

Classificar e expor no response o formato do carrossel gerado, permitindo diferenciação entre estilos de apresentação para consumo pelos clientes.

---

## 2. Escopo Entregue

### 2.1 Formatos Suportados
- [x] CONTINUO: padrão para fluxos com narrativa sequencial.
- [x] IMAGEM_UNICA: priorizado quando `quantidade <= 4`.
- [x] TEMATICO: priorizado para nicho `educacional`.
- [x] MIXTO: priorizado quando o texto contém citações (aspas `"`).

### 2.2 Implementação
- [x] Heurísticas em `CarouselGeneratorService.selectFormato(...)` determinam `response.formato`.
- [x] `GenerateCarouselResponse` já inclui o campo `formato`.
- [x] Testes unitários cobrindo seleção de formato em `Epic5CarouselTypesTest`.

---

## 3. Decisões Técnicas

| Decisão | Motivo |
| :-- | :-- |
| Heurísticas simples por quantidade, nicho e presença de citações | Rapidez de implementação e previsibilidade |
| Manter composição de slides existente | Evitar regressões; clientes podem decidir renderização por `formato` |

---

## 4. Pendências / Próximas Etapas

| Tipo | Descrição |
| :-- | :-- |
| Melhoria | Permitir `formato` opcional no request para forçar comportamento |
| Melhoria | Ajustar layouts padrão por `formato` (ex.: IMAGEM_UNICA com ênfase visual) |
| Observabilidade | Métricas por `formato` gerado |

---

## 5. Evidências

- Testes passam validando os 4 formatos suportados.
- `formato` presente nas respostas do endpoint `POST /api/generate-carousel`.

