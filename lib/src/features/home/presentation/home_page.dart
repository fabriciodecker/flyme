import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_strings.dart';
import '../../admin_users/presentation/admin_users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.userEmail});

  final String? userEmail;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _saving = false;

  Stream<bool> _isAdminStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Stream<bool>.value(false);
    }

    return FirebaseFirestore.instance
        .collection('admin_users')
        .doc(uid)
        .snapshots()
        .map((doc) {
          final data = doc.data();
          if (data == null) {
            return false;
          }
          return data['isAdmin'] == true;
        });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _saveFirestoreHealthcheck() async {
    if (_saving) {
      return;
    }

    setState(() => _saving = true);

    try {
      await FirebaseFirestore.instance.collection('healthcheck').add({
        'createdAt': FieldValue.serverTimestamp(),
        'userEmail': widget.userEmail,
        'source': 'flyme_app',
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Documento salvo em healthcheck.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao salvar no Firestore.')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            onPressed: _saving ? null : _saveFirestoreHealthcheck,
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Salvar teste Firestore',
          ),
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<bool>(
          stream: _isAdminStream(),
          builder: (context, snapshot) {
            final isAdmin = snapshot.data ?? false;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.userEmail == null
                      ? 'Login realizado com sucesso.'
                      : 'Login realizado: ${widget.userEmail}',
                ),
                const SizedBox(height: 8),
                Text(isAdmin ? 'Perfil: admin' : 'Perfil: usuário comum'),
                const SizedBox(height: 8),
                const Text('Use o botão abaixo (ou ícone na barra) para testar Firestore.'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _saving ? null : _saveFirestoreHealthcheck,
                  child: Text(
                    _saving ? 'Salvando...' : 'Salvar teste Firestore',
                  ),
                ),
                const SizedBox(height: 12),
                if (isAdmin)
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AdminUsersPage()),
                      );
                    },
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                    label: const Text('Gerenciar usuários (admin)'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
