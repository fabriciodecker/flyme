import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final CollectionReference<Map<String, dynamic>> _usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> _openUserDialog({DocumentSnapshot<Map<String, dynamic>>? doc}) async {
    final data = doc?.data() ?? <String, dynamic>{};
    final nameController = TextEditingController(text: (data['name'] ?? '') as String);
    final emailController = TextEditingController(text: (data['email'] ?? '') as String);
    var role = (data['systemRole'] ?? 'common') as String;
    var isActive = (data['isActive'] ?? true) as bool;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(doc == null ? 'Novo usuário' : 'Editar usuário'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: role,
                      decoration: const InputDecoration(labelText: 'Perfil de sistema'),
                      items: const [
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'common', child: Text('Usuário comum')),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setStateDialog(() => role = value);
                      },
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Ativo'),
                      value: isActive,
                      onChanged: (value) => setStateDialog(() => isActive = value),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();

                    if (name.isEmpty || !email.contains('@')) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(content: Text('Preencha nome e email válidos.')),
                      );
                      return;
                    }

                    final payload = <String, dynamic>{
                      'name': name,
                      'email': email,
                      'systemRole': role,
                      'isActive': isActive,
                      'updatedAt': FieldValue.serverTimestamp(),
                    };

                    if (doc == null) {
                      payload['createdAt'] = FieldValue.serverTimestamp();
                      await _usersRef.add(payload);
                    } else {
                      await _usersRef.doc(doc.id).update(payload);
                    }

                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
  }

  Future<void> _deleteUser(DocumentSnapshot<Map<String, dynamic>> doc) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir usuário'),
          content: const Text('Confirma a exclusão deste usuário?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _usersRef.doc(doc.id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin · Usuários')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openUserDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('Novo usuário'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _usersRef.orderBy('name').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Falha ao carregar usuários.'));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum usuário cadastrado.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final name = (data['name'] ?? '') as String;
              final email = (data['email'] ?? '') as String;
              final role = (data['systemRole'] ?? 'common') as String;
              final isActive = (data['isActive'] ?? false) as bool;

              return Card(
                child: ListTile(
                  title: Text(name.isEmpty ? '(sem nome)' : name),
                  subtitle: Text('$email · role: $role · ativo: $isActive'),
                  onTap: () => _openUserDialog(doc: doc),
                  trailing: IconButton(
                    onPressed: () => _deleteUser(doc),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
