import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptionsDev {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptionsDev não está configurado para esta plataforma.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD4QOC-sCa3-xSuLrzVnqg81S2tyROUD0o',
    appId: '1:164953344863:web:310854900d016ff90e44ea',
    messagingSenderId: '164953344863',
    projectId: 'flyme-dev-60e80',
    authDomain: 'flyme-dev-60e80.firebaseapp.com',
    storageBucket: 'flyme-dev-60e80.firebasestorage.app',
    measurementId: 'G-3G7YPYDJ3C',
  );
}
