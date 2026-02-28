import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import 'theme.dart';

class BootstrapErrorApp extends StatelessWidget {
  const BootstrapErrorApp({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.appName)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Configuração do Firebase pendente',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Finalize a configuração local seguindo docs/firebase_setup.md e reinicie o app.',
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
