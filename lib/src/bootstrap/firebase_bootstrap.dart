import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options_dev.dart';

class FirebaseBootstrap {
  static Future<void> initialize() async {
    const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

    if (appEnv == 'prod') {
      throw UnsupportedError(
        'APP_ENV=prod ainda não configurado. Adicione firebase_options_prod.dart.',
      );
    }

    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptionsDev.currentPlatform,
      );
      return;
    }

    await Firebase.initializeApp();
  }
}
