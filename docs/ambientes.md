# FlyMe — Plano de Ambientes (Firebase)

## Objetivo
Separar desenvolvimento/testes de produção para evitar mistura de dados e reduzir risco operacional.

## Ambientes oficiais
- `dev`: desenvolvimento e homologação funcional.
- `prod`: produção com dados reais.

## Projetos Firebase sugeridos
- `flyme-dev`
- `flyme-prod`

## Estrutura recomendada no Firebase
Para **cada ambiente**:
- Firebase Authentication habilitado.
- Cloud Firestore habilitado.
- Regras de segurança próprias do ambiente.
- Apps registrados por plataforma (Android, iOS, Web, Linux se necessário).

## Estratégia de configuração no Flutter
Gerar opções separadas por ambiente com `flutterfire configure`:
- `lib/firebase_options_dev.dart`
- `lib/firebase_options_prod.dart`

Selecionar ambiente via `dart-define` na execução/build:
- `--dart-define=APP_ENV=dev`
- `--dart-define=APP_ENV=prod`

## Fluxo de trabalho recomendado
1. Desenvolver e validar em `dev`.
2. Testar regras de segurança e autenticação em `dev`.
3. Publicar build de produção apontando para `prod`.

## Governança de dados
- Nunca usar dados reais em `dev`.
- Não compartilhar credenciais de admin de `prod` com equipe técnica.
- Revisar regras de Firestore antes de cada release para `prod`.

## Checklist de release para produção
- [ ] App validado em `dev`.
- [ ] Regras de Auth/Firestore revisadas.
- [ ] Build com `APP_ENV=prod` confirmado.
- [ ] Conta admin inicial de produção criada e testada.
- [ ] Logs e trilha de auditoria verificados.
