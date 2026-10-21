import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import '../widgets/surface_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.loggedIn,
    required this.name,
    required this.email,
    required this.pro,
    required this.onUpgrade,
    required this.onAuth,
    required this.onEdit,
    required this.onMixer,
    required this.onLogout,
    required this.onToast,
    required this.onNotifications,
  });

  final bool loggedIn;
  final String name;
  final String email;
  final bool pro;
  final VoidCallback onUpgrade, onAuth, onEdit, onMixer, onLogout, onNotifications;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(RegExp(r'\s+')).map((part) => part[0]).take(2).join().toUpperCase();

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        AppHeader(title: 'Profil', subtitle: 'Kelola akun dan preferensi AudiCo', onNotifications: onNotifications),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SurfaceCard(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(radius: 29, backgroundColor: const Color(0xFF28664E), child: Text(initials, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(loggedIn ? name : 'Belum masuk', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(loggedIn ? email : 'Masuk untuk menyimpan profil', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ]),
                ),
                if (loggedIn) IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        if (!pro && loggedIn) Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: FilledButton.icon(onPressed: onUpgrade, icon: const Icon(Icons.workspace_premium), label: const Padding(padding: EdgeInsets.symmetric(vertical: 13), child: Text('Upgrade ke PRO')))),
        const SizedBox(height: 10),
        if (!loggedIn) _setting(Icons.login, 'Masuk atau daftar', onAuth),
        if (loggedIn) ...[
          _setting(Icons.person_outline, 'Edit profil', onEdit),
          _setting(Icons.tune, 'Pengaturan audio', onMixer),
          _setting(Icons.help_outline, 'Bantuan & tentang AudiCo', () => onToast('AudiCo MVP • semua layanan masih lokal (mock)')),
          _setting(Icons.logout, 'Keluar', onLogout),
        ],
        const Padding(padding: EdgeInsets.all(24), child: Text('v1.0.0 MVP • Akun dummy untuk demo', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 11))),
      ],
    );
  }

  Widget _setting(IconData icon, String title, VoidCallback onTap) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 24), leading: Icon(icon, color: Colors.grey.shade300), title: Text(title), trailing: const Icon(Icons.chevron_right, size: 20), onTap: onTap);
}
