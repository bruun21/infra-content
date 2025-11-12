# Encerramento de Épico - Tipos de Slides e Estrutura Narrativa (Concluído)

> Período de Desenvolvimento: 30/10/2025 - 30/10/2025  
> Responsáveis: Agente Codex CLI  
> Contexto do Projeto: Gerador de Carrossel

---

## 1. Objetivo do Épico

Implementar tipos de slides (intro, contexto, insight, dado_apoio, exemplo_pratico, cta) e organizar a sequência narrativa do carrossel.

---

## 2. Escopo Entregue

### 2.1 Funcionalidades
- [x] E3-H1: `intro` sempre primeiro, 1 ocorrência, layout `titulo_centralizado`.
- [x] E3-H2: `contexto` extraído dos 2 primeiros parágrafos, 1–2 frases, posicionado logo após a intro quando há espaço.
- [x] E3-H3: `insight` dos parágrafos centrais; mínimo 40% do total; numeração quando >3.
- [x] E3-H4: `dado_apoio` com detecção de percentuais e números; título destacando o valor.
- [x] E3-H5: `exemplo_pratico` detectando expressões (“por exemplo”, “como quando”, “imagine que”).
- [x] E3-H6: `cta` sempre último, 1 ocorrência, templates por nicho.

### 2.2 Regras de Composição
- [x] Segmentação 1–2 frases por slide com limite de 240 caracteres.
- [x] Recorte final preserva `intro` e `cta` para manter o total solicitado (`quantidade`).
- [x] Layouts sugeridos por tipo (`titulo_centralizado`, `duas_colunas`, `texto_em_destaque`, `cta_central`).

---

## 3. Decisões Técnicas

| Decisão | Motivo / Justificativa |
| :---- | :---- |
| Classificação por heurísticas simples | Baixa complexidade e previsibilidade |
| Numeração de insights quando >3 | Melhora a legibilidade em sequências longas |

---

## 4. Pendências / Próximas Etapas

| Tipo | Descrição | Responsável |
| :---- | :---- | :---- |
| Teste | Adicionar testes para classificação e composição | - |
| Melhoria | Afinar heurísticas de `dado_apoio` e `exemplo_pratico` | - |

---

## 5. Evidências

- Ver resposta do endpoint em diferentes `baseText` (parágrafos múltiplos; números; “por exemplo”).

