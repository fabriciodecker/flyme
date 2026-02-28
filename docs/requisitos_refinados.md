# FlyMe — Requisitos Refinados (v8)

## 1) Objetivo do produto
Aplicativo mobile (iOS e Android) para gestão operacional e financeira de voos de parapente em clube de voo livre.

Objetivos principais:
- Controlar agenda de voos.
- Registrar eventos financeiros por voo.
- Controlar repasse de voos entre pilotos (seller/operator).
- Gerar fechamento diário e resumo por ator (quem recebe/paga).
- Funcionar offline com sincronização automática quando houver internet.

## 2) Escopo MVP (primeira entrega)
### 2.1 Funcionalidades incluídas
1. Autenticação:
   - Login com Google.
   - Login com email/senha.
   - Recuperação de senha.

2. Cadastros essenciais (somente admin):
   - Usuários.
   - Clubes.
   - Papéis (`Pilot`, `Driver`, `Folder`, `Data Transfer`, `Operator`, `Club`).
   - Relação usuário ↔ papéis.
   - Relação usuário ↔ clube (um usuário pode pertencer a um ou mais clubes).
   - Catálogo de eventos de voo (descrição e valor sugerido).

3. Agenda de voos:
   - Visualização em calendário.
   - Visualização em grade diária.
   - Filtros mínimos:
     - Agendados por mim para eu voar.
     - Agendados por mim para outro piloto voar.
     - Agendados por outro piloto para eu voar.
   - Criar, editar, visualizar e excluir voo.
   - Ao criar voo, enviar convite para um ou mais pilotos.
   - Definir no primeiro envio a estratégia de reencaminhamento automático em caso de expiração (para outro piloto e/ou grupo de pilotos).
   - Pilotos convidados podem aceitar o voo.
   - O primeiro aceite define o piloto executor do voo.

4. Favoritos e grupos de pilotos:
   - Usuário pode salvar pilotos favoritos.
   - Usuário pode criar grupos de pilotos para convites rápidos e fallback de expiração.

5. Voo e eventos financeiros:
   - Cadastro dos dados básicos do voo.
   - Registro de eventos financeiros de receita/despesa.
   - Registro de quem recebeu o valor base do voo (executor ou terceiro).
   - Marcação de pagamento (`open` / `done`) por evento.
   - Suporte a seller/operator com comissão.
   - Suporte a câmera extra (quantidade e valor unitário).

6. Templates de voo:
   - Salvar voo com eventos como template nomeado.
   - Criar novo voo a partir de template.

7. Financeiro:
   - Tela de fechamento diário (em aberto vs pagos).
   - Tela de resumo de pagamentos por ator.

8. Offline-first:
   - Operações principais funcionam sem internet.
   - Sincronização automática ao reconectar.

9. Notificações:
   - Área de notificações no app para histórico de alertas.
   - Notificação automática quando um voo for atribuído a um piloto.
   - Alarme sonoro configurável por usuário para notificações de atribuição.
   - Opção de som com alta audibilidade para ambiente barulhento.

### 2.2 Fora do escopo do MVP (fase posterior)
- Integração com gateways de pagamento.
- Conciliação bancária automática.
- Relatórios avançados (BI).
- Regras avançadas por clube (políticas financeiras e operacionais totalmente customizadas por clube).
- Notificações push avançadas e automações complexas.

## 3) Perfis e permissões (proposta inicial)
Perfis de atuação (papéis de negócio):
- `Pilot`: executa voo.
- `Operator` (seller): vende voo para outro piloto executar.
- `Driver`, `Folder`, `Data Transfer`, `Club`: participantes financeiros do voo.

Perfis de sistema (acesso):
- `Admin`: gerencia cadastros essenciais e parâmetros globais.
- `Usuário comum`: opera apenas voos próprios e voos atribuídos, conforme regras.

Permissões mínimas no MVP:
- Admin pode fazer CRUD de usuários, clubes, papéis, relação usuário ↔ papéis, relação usuário ↔ clube e catálogo de eventos.
- Usuário comum não pode alterar cadastros essenciais nem catálogo de eventos.
- Usuário autenticado pode criar voos.
- Usuário comum pode fazer CRUD completo apenas dos voos criados por ele.
- Usuário comum pode editar voo criado por outro usuário quando estiver atribuído a ele como executor.
- Exclusão de voo permitida apenas para criador do voo.
- Marcação de pagamento (`done`) permitida ao criador, piloto executante e seller.
- Usuário comum pode manter seus próprios favoritos de pilotos e seus grupos de pilotos.

> Observação: regras de permissão podem ser ajustadas após validação com operação real.

## 4) Regras de negócio refinadas
### 4.1 Voo
- Um voo possui:
  - Data/hora agendada.
   - Clube de operação (`club_id`).
   - Piloto executante (`pilot_id`) opcional até o aceite.
   - Lista de pilotos convidados para aceite.
   - Estratégia de fallback de convites configurada no primeiro envio.
  - Seller/operator opcional (`seller_id`).
  - Valor base (`base_value`).
   - Status de voo: `scheduled`, `finished`, `canceled`.
   - Status de atribuição: `unassigned`, `pending_acceptance`, `assigned`.

### 4.2 Eventos financeiros
- Todo evento financeiro pertence a um voo.
- Todo evento financeiro é criado a partir de um evento pré-cadastrado no catálogo (com opção de ajuste do valor no lançamento).
- Todo evento tem:
   - Tipo/descrição (ex.: recebimento voo, recebimento por terceiro, taxa clube, subida, dobra, comissão seller, venda câmera extra, transferência de mídia).
   - Referência ao item de catálogo (`event_catalog_id`).
  - Valor com sinal:
    - Receita: valor positivo.
    - Despesa: valor negativo.
   - Ator beneficiário/responsável (`user_id` do saldo impactado).
   - Contraparte opcional (`counterparty_user_id`) para eventos de repasse/acerto.
  - Status de pagamento: `open` ou `done`.
  - Comentário opcional.

### 4.3 Comissão do seller
- Se houver seller, pode existir evento de comissão para o seller.
- Valor da comissão é parametrizável (não fixo no código).
- Comissão é registrada como despesa para quem executa/paga.
- Quando o executor receber do cliente, a comissão do seller deve ficar explícita como valor a pagar ao seller.

### 4.4 Recebimento do voo e acerto entre envolvidos
- No voo criado por mim para mim, deve ser possível registrar quem recebeu o valor base do cliente.
- O recebedor do valor base do voo é independente do recebedor de receitas adicionais (ex.: câmera extra).
- Cenário A: executor recebe diretamente.
   - Registrar recebimento do voo como receita positiva do executor.
   - Esse valor já compõe saldo positivo do executor.
- Cenário B: terceiro recebe para o executor.
   - Registrar no voo quem foi o recebedor.
   - Lançar evento financeiro negativo para o executor, com `payment_status = open`, indicando que a contraparte deve repassar ao executor.
   - O evento deve identificar claramente quem precisa pagar (contraparte).
- Cenário C: seller repassa voo para o executor e seller recebe antecipadamente.
   - Registrar seller como recebedor do valor base.
   - Lançar evento negativo para o executor, em aberto, com contraparte seller (seller deve pagar depois ao executor).
- Cenário D: seller repassa voo para o executor e executor recebe do cliente.
   - Registrar recebimento positivo para o executor.
   - Lançar comissão do seller como despesa do executor (aberta ou paga, conforme liquidação).
- Cenário E: seller recebe o valor base do voo e executor recebe câmera extra.
   - Registrar seller como recebedor do valor base (`fare_collector_user_id`).
   - Registrar venda de câmera extra como evento de receita positiva para o executor.
   - A separação deve ficar explícita no extrato do voo, sem misturar recebedor do valor base com recebedor da câmera extra.

### 4.5 Câmera extra
- Permitido adicionar zero ou mais câmeras extras por voo.
- Cada câmera extra gera:
  - Receita adicional (valor negociado; padrão sugerido 300).
  - Opcionalmente, despesa de transferência por mídia (padrão sugerido 15 por câmera).
- O recebedor da câmera extra deve ser registrado no evento financeiro da câmera (campo `user_id` do evento), podendo ser diferente do recebedor do valor base do voo.

### 4.6 Fechamento diário
- Considera eventos por data operacional do voo.
- Deve exibir:
  - Total em aberto (`open`).
  - Total pago (`done`).
  - Saldo líquido do dia.

### 4.7 Convite e aceite de piloto
- Na criação do voo, o criador pode convidar um ou mais pilotos.
- Cada convite possui status: `pending`, `accepted`, `declined`, `expired`, `canceled`.
- Cada convite pode ter prazo de expiração (`expires_at`) em minutos, ou ficar sem expiração.
- Valor padrão de expiração quando habilitado: 15 minutos (editável pelo criador no envio).
- Quando não houver expiração, o convite permanece `pending` até aceite/recusa do piloto ou cancelamento pelo criador do voo.
- Regra de aceite no MVP: primeiro piloto que aceitar torna-se executor (`pilot_id`).
- Regra de concorrência no aceite:
   - Se dois pilotos aceitarem em paralelo com internet, vence o primeiro aceite confirmado no servidor.
   - Se os dois aceitarem offline, vence quem sincronizar primeiro ao voltar online.
- Após aceite, convites pendentes do mesmo voo são automaticamente cancelados.
- Enquanto não houver aceite, voo permanece sem executor e com status de atribuição `pending_acceptance`.
- Ao expirar convite sem aceite, o sistema aplica a estratégia definida no primeiro envio:
   - reenviar para outro piloto específico, e/ou
   - reenviar para outro grupo de pilotos pré-configurado.

### 4.8 Multi-clube e favoritos
- Usuário pode estar vinculado a um ou mais clubes simultaneamente.
- Todo voo deve estar associado a um clube.
- Convites devem considerar pilotos vinculados ao clube do voo.
- Usuário pode salvar pilotos favoritos para agilizar convites.
- Usuário pode salvar grupos de pilotos favoritos para uso em convite inicial e fallback de expiração.

### 4.9 Notificações de atribuição
- Quando um voo for atribuído a um piloto (por aceite ou atribuição direta), o piloto deve receber notificação.
- A notificação deve ser registrada no histórico interno do app (área de notificações).
- A notificação de atribuição deve tocar alarme sonoro conforme preferência do usuário.
- O usuário pode configurar volume do alarme e escolher o som da notificação.
- O som pode ser um alarme do app ou um toque personalizado do aparelho (ringtone).
- Deve existir perfil de alta audibilidade para ambientes barulhentos.
- Se o dispositivo estiver offline no momento do evento, a notificação deve ser entregue quando houver sincronização.

## 5) Modelo de dados (Firebase) — proposta de coleções
Coleções principais:
- `users`
- `clubs`
- `roles`
- `user_roles`
- `user_clubs`
- `pilot_favorites`
- `pilot_groups`
- `pilot_group_members`
- `flight_statuses`
- `payment_statuses`
- `event_catalog`
- `flights`
- `flight_assignments`
- `flight_events`
- `flight_templates`
- `notifications`
- `user_notification_preferences`
- `audit_logs`
- `app_parameters`

Campos mínimos sugeridos:

### `flights`
- `id`
- `schedule_at` (timestamp)
- `club_id`
- `pilot_id` (nullable, preenchido após aceite)
- `seller_id` (nullable)
- `base_value`
- `fare_collector_user_id` (nullable, quem recebeu o valor base do cliente)
- `fare_collection_mode` (`executor_received` | `third_party_received`)
- `flight_status` (`scheduled` | `finished` | `canceled`)
- `assignment_status` (`unassigned` | `pending_acceptance` | `assigned`)
- `fallback_config` (regra de reenvio por expiração)
- `created_by`
- `updated_by`
- `created_at`
- `updated_at`
- `sync_version` (controle de conflito)
- `deleted_at` (nullable, exclusão lógica)

### `clubs`
- `id`
- `name`
- `is_active`
- `created_at`
- `updated_at`

### `user_clubs`
- `id`
- `user_id`
- `club_id`
- `is_default`
- `created_at`

### `pilot_favorites`
- `id`
- `owner_user_id`
- `pilot_user_id`
- `created_at`

### `pilot_groups`
- `id`
- `owner_user_id`
- `name`
- `created_at`
- `updated_at`

### `pilot_group_members`
- `id`
- `pilot_group_id`
- `pilot_user_id`
- `created_at`

### `event_catalog`
- `id`
- `description`
- `suggested_amount`
- `direction` (`income` | `expense`)
- `is_active`
- `created_at`
- `updated_at`

### `flight_assignments`
- `id`
- `flight_id`
- `pilot_user_id`
- `invited_by`
- `assignment_status` (`pending` | `accepted` | `declined` | `expired` | `canceled`)
- `invited_at`
- `expires_at` (nullable)
- `responded_at` (nullable)
- `accepted_at_device` (nullable)
- `accepted_at_server` (nullable)
- `created_at`
- `updated_at`

### `flight_events`
- `id`
- `flight_id`
- `event_type`
- `amount`
- `user_id` (saldo impactado)
- `counterparty_user_id` (nullable, quem deve pagar/receber no acerto)
- `payment_status` (`open` | `done`)
- `comment`
- `created_by`
- `updated_by`
- `created_at`
- `updated_at`
- `sync_version`

### `flight_templates`
- `id`
- `name`
- `owner_user_id`
- `base_value`
- `default_events[]`
- `created_at`
- `updated_at`

### `notifications`
- `id`
- `user_id`
- `type` (`flight_assigned`)
- `title`
- `body`
- `related_entity_type` (`flight`)
- `related_entity_id`
- `is_read`
- `sent_at`
- `delivered_at` (nullable)
- `created_at`

### `user_notification_preferences`
- `id`
- `user_id`
- `flight_assigned_enabled` (boolean)
- `sound_enabled` (boolean)
- `sound_profile` (`default` | `high_audibility` | `custom`)
- `sound_volume` (0 a 100)
- `sound_uri` (nullable, ringtone/arquivo escolhido pelo usuário)
- `updated_at`

### `app_parameters`
- `default_camera_extra_value`
- `default_media_transfer_value`
- `default_club_fee`
- `default_insurance_fee`
- `default_seller_commission`
- `seller_commission_type` (`fixed`)
- `default_invite_expiration_minutes` (`15`)

### `audit_logs`
- `id`
- `entity_type` (`flight` | `flight_assignment` | `flight_event`)
- `entity_id`
- `action` (`create` | `update` | `delete` | `accept` | `cancel` | `status_change`)
- `changed_fields[]`
- `before` (snapshot resumido)
- `after` (snapshot resumido)
- `performed_by`
- `performed_at`

## 6) Requisitos não funcionais refinados
1. Plataforma:
   - Flutter (iOS/Android).
   - Firebase Auth + Firestore.

2. Offline e sincronização:
   - Persistência local com fila de operações.
   - Operações offline permitidas no MVP: criar voo, editar voo, aceitar voo.
   - Regra de conflito para aceite de voo: primeiro aceite confirmado no servidor vence; em aceite concorrente offline, quem sincronizar primeiro leva.
   - Para demais entidades, estratégia inicial: `last-write-wins` + `sync_version` + log de auditoria.

3. Segurança:
   - Regras de segurança do Firestore por usuário/permissão.
   - Escrita em `users`, `clubs`, `roles`, `user_roles`, `user_clubs`, `event_catalog` e `app_parameters` permitida apenas para admin.
   - Escrita em `pilot_favorites`, `pilot_groups` e `pilot_group_members` permitida apenas ao próprio dono dos dados.
   - Dados sensíveis com princípio do menor privilégio.
   - Tráfego protegido por TLS (padrão Firebase).

4. Qualidade:
   - Testes unitários para regras financeiras críticas.
   - Testes de integração para fluxos de agenda, voo e fechamento.

5. Auditoria mínima (MVP):
   - Registrar trilha obrigatória para: criação/edição/exclusão lógica de voo.
   - Registrar trilha obrigatória para: convite de piloto (envio, aceite, recusa, cancelamento, expiração).
   - Registrar trilha obrigatória para: criação/edição de eventos financeiros, alteração de valor e mudança de `payment_status`.
   - Cada log deve conter: quem fez, quando fez e quais campos foram alterados (antes/depois).

## 7) Backlog priorizado (épicos e histórias)
### Épico A — Base técnica e autenticação
- A1: Configurar projeto Flutter + Firebase.
- A2: Login Google.
- A3: Login email/senha.
- A4: Recuperação de senha.
- A5: Controle de acesso por perfil de sistema (`Admin` x `Usuário comum`).

### Épico B — Agenda de voos
- B1: Listagem em calendário.
- B2: Grade diária.
- B3: Filtros de voos por responsabilidade.
- B4: CRUD de voo.
- B5: Convite de um ou mais pilotos por voo.
- B6: Aceite/recusa de convite pelo piloto.
- B7: Expiração de convite com reenvio automático por estratégia configurada no primeiro envio.
- B8: Convite sem expiração (pendente até cancelamento do criador).

### Épico B2 — Multi-clube e favoritos
- B2.1: Vincular usuário a um ou mais clubes.
- B2.2: Associar voo a um clube.
- B2.3: Cadastro de pilotos favoritos por usuário.
- B2.4: Cadastro de grupos de pilotos favoritos por usuário.

### Épico C — Financeiro por voo
- C1: Cadastro de catálogo de eventos (descrição + valor sugerido) por admin.
- C2: CRUD de eventos financeiros a partir do catálogo.
- C3: Controle de status de pagamento por evento.
- C4: Regras de seller/comissão.
- C5: Câmera extra e transferência.
- C6: Regras de recebimento do valor base e repasse entre executor/terceiro/seller.

### Épico D — Templates
- D1: Salvar template de voo.
- D2: Criar voo a partir de template.

### Épico E — Fechamento e resumo
- E1: Fechamento diário.
- E2: Resumo por ator.

### Épico F — Offline e sincronização
- F1: Cache local e operação offline.
- F2: Sincronização automática.
- F3: Tratamento de conflitos.

### Épico G — Notificações
- G1: Área de notificações (histórico e leitura).
- G2: Disparo de notificação ao atribuir voo para piloto.
- G3: Preferências de notificação e som configurável.
- G4: Perfil de som de alta audibilidade.
- G5: Seleção de toque personalizado (ringtone) pelo usuário.

### Épico H — Auditoria mínima
- H1: Registrar auditoria de CRUD de voos.
- H2: Registrar auditoria de ciclo de convites (envio/aceite/recusa/cancelamento/expiração).
- H3: Registrar auditoria de eventos financeiros e mudanças de pagamento.
- H4: Consultar trilha por voo para suporte operacional.

## 8) Critérios de aceite do MVP
- Usuário autentica via Google ou email/senha e recupera senha.
- Somente admin faz CRUD de cadastros essenciais e catálogo de eventos.
- Somente admin faz CRUD de clubes e vínculo usuário ↔ clube.
- Usuário comum não consegue alterar cadastros essenciais nem catálogo de eventos.
- Usuário comum mantém apenas seus favoritos/grupos de pilotos.
- Usuário faz CRUD completo de voos criados por ele.
- Usuário edita voo de outro criador quando esse voo estiver atribuído a ele como executor.
- Usuário cria voo convidando um ou mais pilotos e o primeiro aceite define executor.
- Convite pode expirar por tempo em minutos ou ficar sem expiração até cancelamento do criador.
- Quando houver expiração configurada e ela ocorrer sem aceite, o sistema reencaminha conforme estratégia definida no primeiro envio.
- Em aceite concorrente offline de dois pilotos, ao reconectar, vence quem sincronizar primeiro.
- Usuário mantém catálogo de eventos de voo com descrição e valor sugerido.
- Usuário registra eventos financeiros a partir do catálogo, com status `open`/`done`.
- Sistema permite registrar quem recebeu o valor base do voo (executor ou terceiro).
- Se executor receber, valor base entra como saldo positivo do executor.
- Se terceiro/seller receber para o executor, sistema lança evento negativo em aberto para o executor com contraparte definida, indicando repasse pendente.
- Se executor receber voo de seller e receber do cliente, sistema lança comissão do seller como despesa do executor.
- Se seller receber valor base e executor receber câmera extra, sistema registra recebedores distintos e ambos aparecem de forma explícita no extrato do voo.
- Piloto recebe notificação quando um voo for atribuído a ele.
- App possui área de notificações com histórico e status de leitura.
- Usuário configura alarme sonoro de notificação, incluindo opção de alta audibilidade.
- Sistema registra auditoria mínima com usuário, data/hora e antes/depois para ações críticas de voo, convites e financeiro.
- Sistema calcula fechamento diário com totais corretos (`open`, `done`, saldo).
- Sistema apresenta resumo por ator.
- Fluxos essenciais funcionam sem internet e sincronizam ao reconectar.

## 9) Decisões fechadas e em aberto
### 9.1 Decisões fechadas nesta revisão
1. Comissão seller:
   - Modelo definido como valor fixo.
2. Política de exclusão:
   - Exclusão lógica com campo `deleted_at`.
3. Conflito offline para aceite de voo:
   - Pode criar voo, editar voo e aceitar voo offline.
   - Em aceite concorrente offline, vence quem sincronizar primeiro.
4. Regra de recebimento e repasse do voo:
   - Registrar quem recebeu o valor base (executor ou terceiro).
   - Recebimento por terceiro/seller para executor gera evento negativo em aberto para executor até repasse.
5. Auditoria mínima do MVP:
   - Trilha obrigatória para voo, convites e eventos financeiros com antes/depois, usuário e timestamp.

### 9.2 Decisões em aberto (próxima revisão)
- Sem decisões pendentes no momento.

## 10) Próximos passos imediatos
1. Congelar escopo MVP (v1.0).
2. Quebrar backlog em sprints com estimativas.
3. Iniciar implementação pelo Épico A.
