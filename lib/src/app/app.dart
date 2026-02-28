import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../features/auth/presentation/auth_gate.dart';
import 'theme.dart';

class FlymeApp extends StatelessWidget {
  const FlymeApp({super.key, this.initialHome});

  final Widget? initialHome;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: initialHome ?? const AuthGate(),
    );
  }
}
