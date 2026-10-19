import 'package:flutter/material.dart';

Future<void> showAuthDialog(BuildContext context, ValueChanged<String> toast) async {
  final email = TextEditingController();
  final password = TextEditingController();
  await showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Selamat datang di AudiCo'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')), const SizedBox(height: 10), TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password'))]), actions: [TextButton(onPressed: () { Navigator.pop(context); toast('Form pendaftaran siap (mock)'); }, child: const Text('DAFTAR')), FilledButton(onPressed: () { Navigator.pop(context); toast('Berhasil masuk (mock)'); }, child: const Text('MASUK'))]));
}

Future<void> showEditProfileDialog(BuildContext context, ValueChanged<String> toast) async {
  final controller = TextEditingController(text: 'Akmal Nuzulla');
  await showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Edit profil'), content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Nama')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('BATAL')), FilledButton(onPressed: () { Navigator.pop(context); toast('Profil berhasil diperbarui (mock)'); }, child: const Text('SIMPAN'))]));
}
