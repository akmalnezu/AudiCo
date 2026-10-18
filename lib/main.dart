import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const AudiCoApp());

class AudiCoApp extends StatelessWidget {
  const AudiCoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF45D49A);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AudiCo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101A1B),
        colorScheme: ColorScheme.fromSeed(seedColor: green, brightness: Brightness.dark),
        fontFamily: 'Roboto',
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: const Color(0xFF1C2929),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      ),
      home: const AudiCoShell(),
    );
  }
}

class AudiCoShell extends StatefulWidget {
  const AudiCoShell({super.key});
  @override State<AudiCoShell> createState() => _AudiCoShellState();
}

class _AudiCoShellState extends State<AudiCoShell> {
  int _tab = 0;
  bool _pro = false;
  bool _online = true;
  bool _scanning = false;
  bool _playing = true;
  String _scene = 'Hujan di Kota';
  late final AudioPlayer _audioPlayer;
  static const _notificationChannel = MethodChannel('audico/notifications');
  final List<String> _tabs = ['Home', 'Marketplace', 'Riwayat', 'Profil'];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _assetForScene(String scene) {
    if (scene == 'Hutan Senja') return 'Forest.mp3';
    if (scene == 'Malam') return 'Night.mp3';
    return 'Rain.mp3';
  }

  Future<void> _playSceneAudio(String scene) async {
    try {
      await _audioPlayer.play(AssetSource(_assetForScene(scene)));
      if (mounted) setState(() => _playing = true);
    } catch (error) {
      _toast('Audio gagal diputar: ${_assetForScene(scene)}');
      debugPrint('AudiCo audio error: $error');
    }
  }

  Future<void> _toggleAudio() async {
    if (_playing) {
      await _audioPlayer.pause();
      if (mounted) setState(() => _playing = false);
    } else {
      await _playSceneAudio(_scene);
    }
  }

  Future<void> _previewPack(String title) async {
    final scene = title.contains('Forest') ? 'Hutan Senja' : title.contains('Night') || title.contains('Horror') ? 'Malam' : 'Hujan di Kota';
    await _playSceneAudio(scene);
    _toast('Preview $title sedang diputar');
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));

  void _startScan() {
    if (!_online) { _toast('Hubungkan internet untuk memulai deteksi AI.'); return; }
    if (!_scanning) {
      // TODO(native integration): request MediaProjection and SYSTEM_ALERT_WINDOW on Android.
      showDialog(context: context, builder: (_) => AlertDialog(
        title: const Text('Izin diperlukan'),
        content: const Text('AudiCo membutuhkan izin tampil di atas aplikasi lain dan perekaman layar untuk membaca suasana komik. Ini adalah simulasi izin pada prototype.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('NANTI')), FilledButton(onPressed: () { Navigator.pop(context); setState(() { _scanning = true; _scene = 'Hujan di Kota'; }); _playSceneAudio('Hujan di Kota'); _notificationChannel.invokeMethod('showScanNotification'); _toast('Overlay aktif • panel kontrol tersedia di notifikasi'); }, child: const Text('AKTIFKAN'))],
      ));
    } else { setState(() => _scanning = false); _audioPlayer.pause(); _notificationChannel.invokeMethod('hideScanNotification'); _toast('Scan overlay dihentikan'); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        if (!_online) Container(width: double.infinity, color: const Color(0xFF7B4C29), padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 18), child: const Row(children: [Icon(Icons.cloud_off, size: 17), SizedBox(width: 8), Expanded(child: Text('Anda sedang offline. Fitur deteksi AI audio tidak tersedia.', style: TextStyle(fontSize: 12)))])),
        Expanded(child: IndexedStack(index: _tab, children: [
          _home(), _marketplace(), _history(), _profile(),
        ])),
      ])),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab, onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: const Color(0xFF152121), indicatorColor: const Color(0xFF244B3D),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Marketplace'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Riwayat'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _header(String title, {String? subtitle}) => Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 12), child: Row(children: [
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: .2)), if (subtitle != null) Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 13))])),
    IconButton(onPressed: () => _toast('Notifikasi kamu sudah terbaru'), icon: const Icon(Icons.notifications_none_rounded)),
  ]));

  Widget _home() => ListView(padding: EdgeInsets.zero, children: [
    Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 0), child: Text('AudiCo', style: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w700, letterSpacing: 1.8))),
    _header('Halo, Akmal 👋', subtitle: 'Siap membuat komik terasa hidup?'),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _statusCard()),
    const SizedBox(height: 18),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [const Expanded(child: Text('Status layanan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),), Switch(value: _online, onChanged: (v) => setState(() => _online = v))])),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _serviceCard()),
    const SizedBox(height: 20),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [const Expanded(child: Text('Deteksi terakhir', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))), TextButton(onPressed: () { final next = _scene == 'Hujan di Kota' ? 'Hutan Senja' : _scene == 'Hutan Senja' ? 'Malam' : 'Hujan di Kota'; setState(() => _scene = next); if (_playing) _playSceneAudio(next); }, child: const Text('Simulasikan'))])),  Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _sceneCard()),
    const SizedBox(height: 24),
  ]);

  Widget _statusCard() => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF205743), Color(0xFF163B35)]), borderRadius: BorderRadius.circular(22)), child: Row(children: [
    Container(width: 52, height: 52, decoration: BoxDecoration(color: Colors.white.withOpacity(.13), shape: BoxShape.circle), child: Icon(_pro ? Icons.workspace_premium : Icons.headphones, color: const Color(0xFF7AF0BA))),
    const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_pro ? 'AudiCo PRO' : 'Paket Gratis', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(_pro ? 'Scan unlimited • Spatial audio aktif' : 'Sisa kuota sesi hari ini', style: TextStyle(color: Colors.white.withOpacity(.72), fontSize: 12)), const SizedBox(height: 10), LinearProgressIndicator(value: _pro ? 1 : .38, backgroundColor: Colors.black26, color: const Color(0xFF69E9AD), minHeight: 6, borderRadius: BorderRadius.circular(8)), if (!_pro) const Padding(padding: EdgeInsets.only(top: 6), child: Text('9 menit dari 15 menit tersisa', style: TextStyle(fontSize: 11, color: Colors.white70)))])),
    if (!_pro) IconButton(onPressed: _upgrade, icon: const Icon(Icons.arrow_forward_ios, size: 16)),
  ]));

  Widget _serviceCard() => Container(padding: const EdgeInsets.all(16), decoration: _box(), child: Row(children: [
    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: (_online ? const Color(0xFF183F32) : Colors.white10), borderRadius: BorderRadius.circular(12)), child: Icon(_online ? Icons.wifi : Icons.wifi_off, color: _online ? const Color(0xFF64E5A8) : Colors.grey)),
    const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_online ? 'Online & siap memindai' : 'Mode offline', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 3), Text(_online ? 'AI server terhubung • latensi normal' : 'Hanya fitur cache yang tersedia', style: TextStyle(fontSize: 12, color: Colors.grey.shade400))])),
    TextButton(onPressed: _startScan, child: Text(_scanning ? 'STOP' : 'SCAN')),
  ]));

  Widget _sceneCard() => Container(padding: const EdgeInsets.all(16), decoration: _box(), child: Row(children: [
    Container(width: 58, height: 58, decoration: BoxDecoration(color: const Color(0xFF203A3C), borderRadius: BorderRadius.circular(16)), child: Icon(_scene == 'Hujan di Kota' ? Icons.grain : Icons.forest, color: const Color(0xFF76D6CF), size: 30)),
    const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_scene, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text('Confidence 94%  •  Audio crossfade aktif', style: TextStyle(color: Colors.grey.shade400, fontSize: 12))])),
    IconButton(onPressed: _toggleAudio, icon: Icon(_playing ? Icons.pause_circle_filled : Icons.play_circle_fill, color: const Color(0xFF55DDA0), size: 32)),
  ]));

  BoxDecoration _box() => BoxDecoration(color: const Color(0xFF172323), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(.05)));

  Widget _marketplace() => ListView(padding: EdgeInsets.zero, children: [
    _header('Marketplace', subtitle: 'Temukan suasana baru untuk ceritamu'),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(padding: const EdgeInsets.all(15), decoration: _box(), child: Row(children: [const Icon(Icons.search, color: Colors.grey), const SizedBox(width: 10), Text('Cari sound pack...', style: TextStyle(color: Colors.grey, fontSize: 14))]))),
    const SizedBox(height: 20),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: const Text('Sound pack pilihan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
    ..._packs.map(_packCard), const SizedBox(height: 20),
  ]);

  final List<Map<String, dynamic>> _packs = const [
    {'title': 'Horror Pack', 'desc': 'Bisikan, detak jantung & kegelapan', 'price': 'Rp 19.000', 'icon': Icons.nightlight_round, 'pro': true},
    {'title': 'Forest Adventure', 'desc': 'Hutan, burung dan angin lembut', 'price': 'Rp 12.000', 'icon': Icons.forest, 'pro': false},
    {'title': 'Action Fantasy', 'desc': 'Pertarungan epik dan energi sihir', 'price': 'Rp 25.000', 'icon': Icons.bolt, 'pro': true},
  ];

  Widget _packCard(Map<String, dynamic> pack) => Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 0), child: Container(padding: const EdgeInsets.all(15), decoration: _box(), child: Row(children: [
    Container(width: 62, height: 76, decoration: BoxDecoration(color: const Color(0xFF243D3D), borderRadius: BorderRadius.circular(14)), child: Icon(pack['icon'] as IconData, color: const Color(0xFF65D7B0), size: 30)),
    const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(pack['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))), if (pack['pro'] as bool) _tag('PRO')]), const SizedBox(height: 5), Text(pack['desc'] as String, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)), const SizedBox(height: 10), Row(children: [OutlinedButton.icon(onPressed: () => _previewPack(pack['title'] as String), icon: const Icon(Icons.play_arrow, size: 16), label: const Text('Preview')), const SizedBox(width: 8), Flexible(child: TextButton(onPressed: () { if ((pack['pro'] as bool) && !_pro) { _upgrade(); } else { _toast('${pack['title']} siap dibeli (mock)'); } }, child: Text((pack['pro'] as bool && !_pro) ? 'PRO' : pack['price'] as String)))])]))
  ])));

  Widget _tag(String text) => Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFB78B35), borderRadius: BorderRadius.circular(6)), child: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)));

  Widget _history() => ListView(padding: EdgeInsets.zero, children: [
    _header('Riwayat', subtitle: 'Transaksi dan aktivitas akun'),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _summaryRow()),
    const SizedBox(height: 18),
    ...[
      ['AudiCo PRO • 1 Bulan', '12 Okt 2026', 'Rp 39.000', Icons.workspace_premium],
      ['Forest Adventure Pack', '02 Okt 2026', 'Rp 12.000', Icons.forest],
      ['AudiCo PRO • 1 Bulan', '12 Sep 2026', 'Rp 39.000', Icons.workspace_premium],
    ].map((item) => Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 10), child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), tileColor: const Color(0xFF172323), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), leading: Icon(item[3] as IconData, color: const Color(0xFF63D8A5)), title: Text(item[0] as String, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text(item[1] as String, style: const TextStyle(fontSize: 12)), trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text(item[2] as String), const Text('Berhasil', style: TextStyle(color: Color(0xFF66D9A6), fontSize: 11))])))),
  ]);

  Widget _summaryRow() => Row(children: [Expanded(child: _metric('3', 'Transaksi')), const SizedBox(width: 10), Expanded(child: _metric('Rp 90k', 'Total pembelian'))]);
  Widget _metric(String value, String label) => Container(padding: const EdgeInsets.all(15), decoration: _box(), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF65DDA8))), const SizedBox(height: 3), Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 12))]));

  Widget _profile() => ListView(padding: EdgeInsets.zero, children: [
    _header('Profil', subtitle: 'Kelola akun dan preferensi AudiCo'),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(padding: const EdgeInsets.all(18), decoration: _box(), child: Row(children: [CircleAvatar(radius: 29, backgroundColor: const Color(0xFF28664E), child: const Text('AN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))), const SizedBox(width: 14), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Akmal Nuzulla', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('akmal@audico.app', style: TextStyle(color: Colors.grey, fontSize: 12))])), IconButton(onPressed: _editProfile, icon: const Icon(Icons.edit_outlined))]))),
    const SizedBox(height: 18),
    if (!_pro) Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: FilledButton.icon(onPressed: _upgrade, icon: const Icon(Icons.workspace_premium), label: const Padding(padding: EdgeInsets.symmetric(vertical: 13), child: Text('Upgrade ke PRO')))),
    const SizedBox(height: 10),
    _setting(Icons.login, 'Masuk atau daftar', _authDialog), _setting(Icons.person_outline, 'Edit profil', _editProfile), _setting(Icons.tune, 'Pengaturan audio', () => _mixer()), _setting(Icons.help_outline, 'Bantuan & tentang AudiCo', () => _toast('AudiCo MVP • semua layanan masih lokal (mock)')), _setting(Icons.logout, 'Keluar', () => _toast('Sesi keluar (mock)')),
    const Padding(padding: EdgeInsets.all(24), child: Text('v1.0.0 MVP • Data tersimpan lokal untuk demo', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 11))),
  ]);

  Widget _setting(IconData icon, String title, VoidCallback onTap) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 24), leading: Icon(icon, color: Colors.grey.shade300), title: Text(title), trailing: const Icon(Icons.chevron_right, size: 20), onTap: onTap);

  void _authDialog() {
    final email = TextEditingController();
    final password = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Selamat datang di AudiCo'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')), const SizedBox(height: 10), TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password'))]), actions: [TextButton(onPressed: () { Navigator.pop(context); _toast('Form pendaftaran siap (mock)'); }, child: const Text('DAFTAR')), FilledButton(onPressed: () { Navigator.pop(context); _toast('Berhasil masuk (mock)'); }, child: const Text('MASUK'))]));
  }

  void _editProfile() { final controller = TextEditingController(text: 'Akmal Nuzulla'); showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Edit profil'), content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Nama')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('BATAL')), FilledButton(onPressed: () { Navigator.pop(context); _toast('Profil berhasil diperbarui (mock)'); }, child: const Text('SIMPAN'))])); }
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
              if (_pro)
                _slider('Spatial audio', .8, setSheet)
              else
                const Text('Spatial audio tersedia untuk PRO', style: TextStyle(color: Colors.amber, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
  Widget _slider(String label, double value, StateSetter setter) => Row(children: [SizedBox(width: 90, child: Text(label)), Expanded(child: Slider(value: value, onChanged: (v) => setter(() {})))]);
  void _upgrade() => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Upgrade AudiCo PRO'), content: const Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Nikmati scan unlimited, spatial audio 3D, dan haptic feedback.'), SizedBox(height: 14), Text('Rp 39.000 / bulan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF65DDA8))), SizedBox(height: 8), Text('Pembayaran ini adalah simulasi untuk prototype.', style: TextStyle(fontSize: 12, color: Colors.grey))]), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('NANTI')), FilledButton(onPressed: () { Navigator.pop(context); setState(() => _pro = true); _toast('Selamat! AudiCo PRO telah aktif (mock)'); }, child: const Text('AKTIFKAN PRO'))]));
  // TODO(backend integration): replace local mock catalog, auth, payments, and AI results with APIs.
}

