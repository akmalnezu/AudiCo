import 'package:flutter/material.dart';

Future<void> showAuthDialog(
  BuildContext context, {
  required ValueChanged<String> onLogin,
  required ValueChanged<String> onRegister,
}) async {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  var registerMode = false;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(registerMode ? 'Buat akun AudiCo' : 'Masuk ke AudiCo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (registerMode) ...[
                TextField(
                  controller: name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                const SizedBox(height: 10),
              ],
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 12),
              Text(
                'Mode demo: data akun hanya disimpan selama aplikasi berjalan.',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => setDialogState(() => registerMode = !registerMode),
            child: Text(registerMode ? 'SUDAH PUNYA AKUN?' : 'DAFTAR AKUN'),
          ),
          FilledButton(
            onPressed: () {
              final enteredEmail = email.text.trim();
              final enteredName = name.text.trim();
              if (enteredEmail.isEmpty || password.text.isEmpty ||
                  (registerMode && enteredName.isEmpty)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lengkapi semua field terlebih dahulu.')),
                );
                return;
              }
              Navigator.pop(dialogContext);
              if (registerMode) {
                onRegister(enteredName);
              } else {
                onLogin(enteredEmail);
              }
            },
            child: Text(registerMode ? 'DAFTAR' : 'MASUK'),
          ),
        ],
      ),
    ),
  );

  name.dispose();
  email.dispose();
  password.dispose();
}

Future<void> showEditProfileDialog(
  BuildContext context,
  ValueChanged<String> onSave,
  String currentName,
) async {
  final controller = TextEditingController(text: currentName);
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Edit profil'),
      content: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(labelText: 'Nama'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('BATAL')),
        FilledButton(
          onPressed: () {
            final value = controller.text.trim();
            if (value.isEmpty) return;
            Navigator.pop(dialogContext);
            onSave(value);
          },
          child: const Text('SIMPAN'),
        ),
      ],
    ),
  );
  controller.dispose();
}

Future<bool> showLogoutDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Keluar dari akun?'),
          content: const Text('Sesi dummy akan diakhiri pada perangkat ini.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('BATAL')),
            FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('YA, KELUAR')),
          ],
        ),
      ) ??
      false;
}
