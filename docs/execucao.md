# FlyMe — Acompanhamento de Execução

## 1) Objetivo deste documento
Registrar a execução do projeto com foco em:
- passos concluídos
- passos em andamento
- próximos passos
- decisões técnicas tomadas
- bloqueios e riscos

> Fonte oficial de escopo: [requisitos_refinados.md](requisitos_refinados.md)

## 2) Status geral
- Data de início: 27/02/2026
- Status atual: Sprint 0 em andamento
- Documento de referência: [requisitos_refinados.md](requisitos_refinados.md)

## 3) Macroplano de execução
1. Preparação técnica do app Flutter + Firebase.
2. Autenticação e perfis de acesso (`Admin` x `Usuário comum`).
3. Cadastros essenciais (admin).
4. Agenda e fluxo de voos (convite, aceite, atribuição).
5. Eventos financeiros por voo e fechamento diário.
6. Notificações e alarme sonoro configurável.
7. Offline/sincronização e resolução de conflitos.
8. Testes, ajustes e entrega MVP.

## 4) Log de execução
### 2026-02-27
- [x] Documento de requisitos refinados criado e evoluído até versão atual.
- [x] Regras de permissão ajustadas para `Admin` e `Usuário comum`.
- [x] Regras de aceite concorrente offline definidas.
- [x] Requisito de notificações com alta audibilidade incorporado.
- [x] Documento de acompanhamento de execução criado.
- [x] Multi-clube incluído no MVP com vínculo usuário ↔ múltiplos clubes.
- [x] Convite com expiração e fallback automático para piloto/grupo definido no primeiro envio.
- [x] Favoritos de pilotos e grupos de pilotos adicionados ao escopo.
- [x] Convite sem expiração definido (permanece pendente até cancelamento do criador).
- [x] Notificação com som ajustável e opção de toque personalizado (ringtone).
- [x] Regras de recebimento do valor base do voo refinadas (executor, terceiro e seller).
- [x] Regra de repasse pendente formalizada com evento negativo em aberto para o executor quando terceiro/seller recebe.
- [x] Separação explícita entre recebedor do valor base e recebedor de câmera extra definida.
- [x] Projeto Flutter inicializado e publicado no GitHub.
- [x] Estrutura base em camadas criada (`lib/src/app`, `lib/src/core`, `lib/src/features`).
- [x] Gerenciamento de estado configurado com `flutter_riverpod`.
- [x] Teste de widget adaptado para a nova base e validado.
- [x] Dependências Firebase adicionadas (`firebase_core`, `firebase_auth`, `cloud_firestore`).
- [x] Bootstrap Firebase com fallback visual de configuração pendente implementado.
- [x] Guia de setup local criado em `docs/firebase_setup.md`.
- [x] Plano formal de ambientes `dev/prod` criado em `docs/ambientes.md`.
- [x] Guia Firebase atualizado para configuração multi-ambiente (`APP_ENV`).
- [x] Tela de login email/senha implementada no app com fluxo de autenticação Firebase.
- [x] Ambiente `flyme-dev` conectado ao app via `firebase_options_dev.dart` para testes web.
- [x] Recuperação de senha implementada via Firebase Auth (`sendPasswordResetEmail`).
- [x] Botão de teste Firestore implementado na Home para gravação em `healthcheck`.
- [x] Auth Gate global implementado para rotear automaticamente entre Login e Home pelo estado de autenticação.
- [x] Login com Google implementado na tela de autenticação.
- [x] CRUD de usuários (admin) implementado com acesso restrito por `admin_users/{uid}.isAdmin`.

## 5) Backlog operacional imediato
### Sprint 0 — Fundação técnica
- [x] Criar projeto Flutter base.
- [x] Configurar Firebase (Auth + Firestore) na base do app.
- [x] Definir estrutura de camadas (dados, domínio, apresentação).
- [x] Configurar gerenciamento de estado.
- [x] Configurar ambiente de desenvolvimento e scripts.

### Sprint 1 — Acesso e autorização
- [x] Implementar login Google.
- [x] Implementar login email/senha.
- [x] Implementar recuperação de senha.
- [x] Implementar guarda de rotas/permissões por perfil de sistema (nível autenticação).

### Sprint 2 — Cadastros admin
- [x] CRUD de usuários.
- [ ] CRUD de clubes.
- [ ] CRUD de papéis.
- [ ] CRUD de vínculo usuário-papel.
- [ ] CRUD de vínculo usuário-clube.
- [ ] CRUD de catálogo de eventos.

### Sprint 3 — Convites, favoritos e fallback
- [ ] Configurar convite com `expires_at`.
- [ ] Configurar opção de convite sem expiração.
- [ ] Configurar estratégia de fallback no primeiro envio do convite.
- [ ] Reenvio automático por expiração para piloto/grupo configurado.
- [ ] CRUD de favoritos de pilotos por usuário.
- [ ] CRUD de grupos de pilotos por usuário.

### Sprint 4 — Financeiro de recebimento e repasse
- [ ] Registrar no voo quem recebeu o valor base (`fare_collector_user_id`).
- [ ] Implementar recebedor de câmera extra por evento (independente do recebedor do valor base).
- [ ] Implementar cenário de recebimento direto pelo executor (saldo positivo imediato).
- [ ] Implementar cenário de recebimento por terceiro/seller com evento negativo em aberto para executor.
- [ ] Implementar contraparte (`counterparty_user_id`) nos eventos de repasse/acerto.
- [ ] Implementar cenário seller: recebeu antecipado e deve repassar ao executor.
- [ ] Implementar cenário seller: executor recebeu e deve pagar comissão.

## 6) Decisões técnicas já fechadas
- Comissão de seller: valor fixo.
- Exclusão de voos: lógica (`deleted_at`).
- Aceite concorrente offline: vence quem sincronizar primeiro.
- Cadastros essenciais e catálogo de eventos: gestão exclusiva de admin.
- Multi-clube entra no MVP.
- Usuário pode estar vinculado a um ou mais clubes.
- Convite tem expiração com fallback automático (piloto/grupo) definido no envio inicial.
- Convite pode ser criado sem expiração e fica pendente até cancelamento do criador.
- Expiração padrão de convite definida em 15 minutos, com possibilidade de alteração no envio.
- Usuário pode manter pilotos favoritos e grupos de pilotos.
- Notificação permite ajuste de volume e seleção de toque personalizado (ringtone).
- Recebimento do valor base do voo deve registrar quem recebeu (executor ou terceiro).
- Recebimento por terceiro/seller para voo do executor gera lançamento negativo em aberto para executor até repasse.
- Quando executor recebe voo de seller e recebe do cliente, comissão do seller é lançada como despesa do executor.
- Recebedor do valor base e recebedor de câmera extra podem ser diferentes e devem aparecer separados no extrato do voo.
- Auditoria mínima do MVP definida para voo, convites e eventos financeiros (com antes/depois, usuário e timestamp).

## 7) Decisões pendentes
- Sem decisões pendentes no momento.

## 8) Blocos e riscos atuais
- Sem bloqueios técnicos registrados até o momento.
- Risco principal: conflitos de sincronização em cenários offline concorrentes.

## 9) Próxima ação recomendada
Iniciar próximo item da Sprint 2: CRUD de clubes.
