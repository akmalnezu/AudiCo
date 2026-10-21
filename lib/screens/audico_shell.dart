import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../services/notification_service.dart';
import '../widgets/dialogs.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'marketplace_screen.dart';
import 'profile_screen.dart';

class AudiCoShell extends StatefulWidget {
  const AudiCoShell({super.key});

  @override
  State<AudiCoShell> createState() => _AudiCoShellState();
}

class _AudiCoShellState extends State<AudiCoShell> {
  int _tab = 0;
  bool _pro = false;
  bool _online = true;
  bool _scanning = false;
  bool _playing = true;
  bool _loggedIn = false;
  String _name = '';
  String _email = '';
  String _scene = 'Hujan di Kota';
  late final AudioService _audio;
  final _notifications = NotificationService();

  @override
  void initState() {
    super.initState();
    _audio = AudioService();
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _play(String scene) async {
    try {
      await _audio.playScene(scene);
      if (mounted) setState(() => _playing = true);
    } catch (error) {
      _toast('Audio gagal diputar: ${_audio.assetForScene(scene)}');
      debugPrint('AudiCo audio error: $error');
    }
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _audio.pause();
      if (mounted) setState(() => _playing = false);
    } else {
      await _play(_scene);
    }
  }

  Future<void> _preview(String title) async {
    final scene = title.contains('Forest')
        ? 'Hutan Senja'
        : title.contains('Night') || title.contains('Horror')
            ? 'Malam'
            : 'Hujan di Kota';
    await _play(scene);
    _toast('Preview $title sedang diputar');
  }

  void _login(String email) {
    setState(() {
      _loggedIn = true;
      _email = email;
      _name = email.split('@').first;
    });
    _toast('Berhasil masuk sebagai $_name (dummy)');
  }

  void _register(String name) {
    setState(() {
      _loggedIn = true;
      _name = name;
      _email = '${name.toLowerCase().replaceAll(' ', '.')}@audico.demo';
    });
    _toast('Akun $_name berhasil dibuat (dummy)');
  }

  Future<void> _logout() async {
    if (!await showLogoutDialog(context)) return;
    setState(() {
      _loggedIn = false;
      _name = '';
      _email = '';
      _pro = false;
    });
    _toast('Kamu berhasil keluar');
  }

  void _showAuth() => showAuthDialog(
        context,
        onLogin: _login,
        onRegister: _register,
      );

  void _editProfile() => showEditProfileDialog(
        context,
        (value) {
          setState(() => _name = value);
          _toast('Profil berhasil diperbarui');
        },
        _name,
      );

  void _upgrade() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Upgrade AudiCo PRO'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nikmati scan unlimited, spatial audio 3D, dan haptic feedback.'),
            SizedBox(height: 14),
            Text('Rp 39.000 / bulan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF65DDA8))),
            SizedBox(height: 8),
            Text('Pembayaran ini adalah simulasi untuk prototype.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('NANTI')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _pro = true);
              _toast('Selamat! AudiCo PRO telah aktif (mock)');
            },
            child: const Text('AKTIFKAN PRO'),
          ),
        ],
      ),
    );
  }

  void _scan() {
    if (!_online) {
      _toast('Hubungkan internet untuk memulai deteksi AI.');
      return;
    }
    if (_scanning) {
      setState(() => _scanning = false);
      _audio.pause();
      _notifications.hideScanNotification();
      _toast('Scan overlay dihentikan');
      return;
    }
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Izin diperlukan'),
        content: const Text('AudiCo membutuhkan izin tampil di atas aplikasi lain dan perekaman layar untuk membaca suasana komik. Ini adalah simulasi izin pada prototype.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('NANTI')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _scanning = true;
                _scene = 'Hujan di Kota';
              });
              _play(_scene);
              _notifications.showScanNotification();
              _toast('Overlay aktif • panel kontrol tersedia di notifikasi');
            },
            child: const Text('AKTIFKAN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        online: _online,
        pro: _pro,
        scanning: _scanning,
        scene: _scene,
        playing: _playing,
        onOnlineChanged: (value) => setState(() => _online = value),
        onScan: _scan,
        onSimulate: () {
          final next = _scene == 'Hujan di Kota'
              ? 'Hutan Senja'
              : _scene == 'Hutan Senja'
                  ? 'Malam'
                  : 'Hujan di Kota';
          setState(() => _scene = next);
          if (_playing) _play(next);
        },
        onToggleAudio: _toggle,
        onUpgrade: _upgrade,
        onNotifications: () => _toast('Notifikasi kamu sudah terbaru'),
      ),
      MarketplaceScreen(
        isPro: _pro,
        onPreview: _preview,
        onUpgrade: _upgrade,
        onPurchase: (pack) => _toast('${pack.title} siap dibeli (mock)'),
        onNotifications: () => _toast('Notifikasi kamu sudah terbaru'),
      ),
      HistoryScreen(onNotifications: () => _toast('Notifikasi kamu sudah terbaru')),
      ProfileScreen(
        loggedIn: _loggedIn,
        name: _name,
        email: _email,
        pro: _pro,
        onUpgrade: _upgrade,
        onAuth: _showAuth,
        onEdit: _editProfile,
        onMixer: _mixer,
        onLogout: _logout,
        onToast: _toast,
        onNotifications: () => _toast('Notifikasi kamu sudah terbaru'),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (!_online)
              Container(
                width: double.infinity,
                color: const Color(0xFF7B4C29),
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                child: const Row(
                  children: [
                    Icon(Icons.cloud_off, size: 17),
                    SizedBox(width: 8),
                    Expanded(child: Text('Anda sedang offline. Fitur deteksi AI audio tidak tersedia.', style: TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            Expanded(child: IndexedStack(index: _tab, children: screens)),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        backgroundColor: const Color(0xFF152121),
        indicatorColor: const Color(0xFF244B3D),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Marketplace'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Riwayat'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  void _mixer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF172323),
      builder: (_) => StatefulBuilder(
        builder: (context, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Audio mixer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              _slider('Suasana', .72, setSheet),
              _slider('Efek suara', .55, setSheet),
              if (_pro) _slider('Spatial audio', .8, setSheet) else const Text('Spatial audio tersedia untuk PRO', style: TextStyle(color: Colors.amber, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slider(String label, double value, StateSetter setter) => Row(
        children: [
          SizedBox(width: 90, child: Text(label)),
          Expanded(child: Slider(value: value, onChanged: (next) => setter(() {}))),
        ],
      );
}
