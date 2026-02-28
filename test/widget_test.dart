// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flyme/src/app/app.dart';
import 'package:flyme/src/features/auth/presentation/login_page.dart';

void main() {
  testWidgets('Renderiza tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FlymeApp(initialHome: LoginPage()),
      ),
    );

    expect(find.text('Login FlyMe'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Entrar com Google'), findsOneWidget);
    expect(find.text('Criar conta de teste'), findsOneWidget);
    expect(find.text('Esqueci minha senha'), findsOneWidget);
  });
}
