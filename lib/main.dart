import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app/app.dart';
import 'src/app/bootstrap_error_app.dart';
import 'src/bootstrap/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await FirebaseBootstrap.initialize();
    runApp(const ProviderScope(child: FlymeApp()));
  } catch (error) {
    runApp(BootstrapErrorApp(errorMessage: error.toString()));
  }
}
