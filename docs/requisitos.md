
FlyMe

FlyMe é um aplicativo para telefone IOS e Android que tem por objetivo controlar os voos de parapente de pilotos de um clube de voo livre.

Tem o objetivo de controlar:

- o agendamento dos voos
- o lançamento dos eventos do voo do ponto de vista financeiro
- o intercâmbio de voos entre pilotos
- o controle financeiro entre os atores do voo
- fechamento diário com saldo para os envolvidos

Descrição geral do funcionamento de um voo de parapente com um turista.

- Existe um clube responsável pela rampa de decolagem e pouso. Nosso piloto usará o Clube São Conrado de Voo Livre - CSCVL, localizado no Rio de Janeiro para este papel.
- Um piloto de parapente, sócio ou não do clube recebe um passageiro, que é chamado de aluno e realiza o voo no clube.
- O piloto de parapente recebe um valor por este voo e paga outros atores por pequenos trabalhos ou taxas envolvidas neste voo.
- Por exemplo.
  - Ex. 1.
    - O piloto Fabricio recebeu um agendamento de um aluno vindo da internet.
    - O aluno paga 850 reais ao piloto.
    - O piloto paga 120 reais para o clube, sendo 100 de taxa e 20 de seguro.
    - O piloto paga 50 reais para um motorista levar ele e o aluno até o topo da montanha.
    - O piloto paga 15 reais para o dobrador guardar o equipamento após o voo
    - O piloto paga 15 reais para uma pessoa transferir os dados do filme feito para o telefone do aluno
    - Pode ser vendida uma ou mais câmeras extras. O valor é negociado mas como padrão é de 300 reais por cada câmera extra. Neste caso o aluno paga o piloto este valor. O piloto paga mais 15 reais pela transferência desta câmera também.
    - Os custos de dobragem, transferência de câmera e subida são opcionais, pois o piloto pode fazer ele mesmo estes trabalhos.
  - Ex. 2
    - O piloto Eduardo recebeu um agendamento de um aluno e repassou este voo para o piloto Fabricio.
    - O piloto Fabricio executa o voo e pode receber o valor ou o valor pode ser pago ao piloto Dudu. Neste caso o piloto Dudu é também chamado de Operador (seller).
    - Todos os valores e eventos deste voo são iguais ao do ex. 1 acrescentando uma comissao de 180 reais paga do piloto que executou o voo para o piloto que vendeu o voo.
    - Estes valores podem ser alterados, foram dados como exemplo.

Requisitos funcionais:

- Autenticação pelo google ou por email e senha.
- Cadastros básicos:
  - Usuário
  - Papeis
  - Papel do usuário
  - Tipo de status
  - Status
- Tela de agenda onde é possível ver os voos:
  - agendados por mim para eu voar.
  - agendados por mim para outro piloto voar.
  - agendado por outro piloto para eu voar.
  - Possível ver em forma de calendário.
  - Possível escolher um dia e ver a grade voos do dia.
  - Entrar em um voo para visualizar ou editar.
  - Excluir um voo.
  - Criar umvoo.
- Cadastro do voo e seus eventos.
  - Ao cadastrar um voo preencher os dados básicos;
  - Possibilitar cadastrar os eventos;
  - Poder salvar um voo com eventos como template e dar nome a este template;
  - O template deve manter os dados de valores e eventos como sugestão;
  - Poder criar um voo usando um template salvo;
- Tela de fechamento diário com valores em aberto e já pagos.
- Tela com resumo dos pagamentos agrupados pelo ator.

Requisitos não funcionais:

- Usar Flutter para desenvolvimento e firebase para o banco.
- Funcionar offline para momentos que não tenho internet, que será uma constante no projeto. A sincronia deve acontecer logo que a internet funcionar.
- Ter autenticação pelo google ou email e senha.
- Ter recuperação de senha.
- Utilizar tecnologias de segurança;

Abaixo uma sugestão de como pode ser o banco de dados.

| user |     |
| --- | --- |
| id  | name |
| --- | --- |
| 1   | Fabricio |
| --- | --- |
| 2   | Cleyton |
| --- | --- |
| 3   | Eduardo Eisenlohr |
| --- | --- |
| 4   | Dani Ireno |
| --- | --- |
| 5   | Alekson |
| --- | --- |
| 6   | Dayane |
| --- | --- |
| 7   | Clube CSCVL |
| --- | --- |

| roles |     |
| --- | --- |
| id  | description |
| --- | --- |
| 1   | Pilot |
| --- | --- |
| 2   | Driver |
| --- | --- |
| 3   | Folder |
| --- | --- |
| 4   | Data Transfer |
| --- | --- |
| 5   | Operator |
| --- | --- |
| 6   | Club |
| --- | --- |

| user_role |     |
| --- | --- |
| user_id | role_id |
| --- | --- |
| 1   | 1   |
| --- | --- |
| 3   | 1   |
| --- | --- |
| 3   | 5   |
| --- | --- |
| 7   | 6   |
| --- | --- |

| status_type |     |
| --- | --- |
| id  | description |
| --- | --- |
| 1   | Flight |
| --- | --- |
| 2   | Payment |
| --- | --- |

| status |     |     |
| --- | --- | --- |
| id  | status_type_id | description |
| --- | --- | --- |
| 1   | 1   | Scheduled |
| --- | --- | --- |
| 2   | 1   | Finished |
| --- | --- | --- |
| 3   | 1   | Canceled |
| --- | --- | --- |
| 4   | 2   | Open (need to be paid) |
| --- | --- | --- |
| 5   | 2   | Done (paid) |
| --- | --- | --- |

| flight | exemplo da linha do tempo para um voo mudando de status ao longo do tempo |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| id  | schedule_date | schedule_time | pilot_id | seller_id | base_value | status_flight |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1   | 01/02/26 | 07:30:00 |     | 3   | 850 | 1   |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 2   | 02/02/2026 | 07:30 | 1   |     | 850 | 1   |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| flight_events |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| id  | flight_id | event_id |     |     | user_id | status | Comments |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1   | 1   | pagto voo | 850 | pago ao piloto | fabricio | done |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 2   | 1   | dobra | \-15 |     | alekson | open |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3   | 1   | subida | \-50 |     | jorge | done |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4   | 1   | comissao seller | \-180 |     | dudu | open |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5   | 1   | taxa clube | \-120 |     | clube | done |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 6   | 1   | venda 360 | 300 |     | fabricio | done |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 7   | 1   | comissao seller 360 | 150 |     | dudu | open |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 8   | 2   | pagto voo | 850 | pago ao piloto | fabricio | done |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 9   | 2   | dobra | \-15 |     | alekson | open |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 10  | 2   | subida | \-50 |     | jorge | done |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 11  | 2   | taxa clube | \-120 |     | clube | done |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 12  | 2   | venda 360 | 300 |     | fabricio | done |     |
| --- | --- | --- | --- | --- | --- | --- | --- |