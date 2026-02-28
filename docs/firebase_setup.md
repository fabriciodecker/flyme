# FlyMe — Configuração Firebase (local e ambientes)

## Pré-requisitos
- Flutter SDK instalado.
- Projeto Firebase criado no console.
- Acesso ao projeto GitHub local.

## 1) Instalar FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

## 2) Login no Firebase
```bash
firebase login
```

## 3) Configurar ambiente `dev`
No diretório raiz do projeto:
```bash
flutterfire configure --project <SEU_PROJECT_ID_DEV> --out=lib/firebase_options_dev.dart
```

## 4) Configurar ambiente `prod`
```bash
flutterfire configure --project <SEU_PROJECT_ID_PROD> --out=lib/firebase_options_prod.dart
```

## 5) Inicializar usando opções geradas (recomendado)
Após gerar os arquivos de opções, atualizar `lib/src/bootstrap/firebase_bootstrap.dart` para escolher o ambiente via `APP_ENV`:

```dart
const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

if (appEnv == 'prod') {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptionsProd.currentPlatform,
  );
} else {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptionsDev.currentPlatform,
  );
}
```

## 6) Rodar app por ambiente
### Dev
```bash
flutter run -d chrome --dart-define=APP_ENV=dev
```

### Produção (simulação local de build)
```bash
flutter run -d chrome --dart-define=APP_ENV=prod
```

## Observações
- Enquanto a configuração não estiver concluída, o app mostra tela de aviso de bootstrap.
- Para CI/CD, manter configurações separadas de `dev` e `prod`.
- Ver plano de ambientes em `docs/ambientes.md`.
