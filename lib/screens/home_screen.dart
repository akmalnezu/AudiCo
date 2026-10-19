import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import '../widgets/surface_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.online, required this.pro, required this.scanning, required this.scene, required this.playing, required this.onOnlineChanged, required this.onScan, required this.onSimulate, required this.onToggleAudio, required this.onUpgrade, required this.onNotifications});
  final bool online, pro, scanning, playing;
  final String scene;
  final ValueChanged<bool> onOnlineChanged;
  final VoidCallback onScan, onSimulate, onToggleAudio, onUpgrade, onNotifications;

  @override
  Widget build(BuildContext context) => ListView(padding: EdgeInsets.zero, children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 0), child: Text('AudiCo', style: TextStyle(fontSize: 14, color: Colors.grey.shade400, fontWeight: FontWeight.w700, letterSpacing: 1.8))),
        AppHeader(title: 'Halo, Akmal', subtitle: 'Siap membuat komik terasa hidup?', onNotifications: onNotifications),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _statusCard()),
        const SizedBox(height: 18),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [const Expanded(child: Text('Status layanan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))), Switch(value: online, onChanged: onOnlineChanged)])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _serviceCard()),
        const SizedBox(height: 20),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [const Expanded(child: Text('Deteksi terakhir', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))), TextButton(onPressed: onSimulate, child: const Text('Simulasikan'))])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _sceneCard()),
        const SizedBox(height: 24),
      ]);

  Widget _statusCard() => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF205743), Color(0xFF163B35)]), borderRadius: BorderRadius.circular(22)), child: Row(children: [Container(width: 52, height: 52, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .13), shape: BoxShape.circle), child: Icon(pro ? Icons.workspace_premium : Icons.headphones, color: const Color(0xFF7AF0BA))), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(pro ? 'AudiCo PRO' : 'Paket Gratis', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(pro ? 'Scan unlimited • Spatial audio aktif' : 'Sisa kuota sesi hari ini', style: TextStyle(color: Colors.white.withValues(alpha: .72), fontSize: 12)), const SizedBox(height: 10), LinearProgressIndicator(value: pro ? 1 : .38, backgroundColor: Colors.black26, color: const Color(0xFF69E9AD), minHeight: 6, borderRadius: BorderRadius.circular(8)), if (!pro) const Padding(padding: EdgeInsets.only(top: 6), child: Text('9 menit dari 15 menit tersisa', style: TextStyle(fontSize: 11, color: Colors.white70)))])), if (!pro) IconButton(onPressed: onUpgrade, icon: const Icon(Icons.arrow_forward_ios, size: 16))]));

  Widget _serviceCard() => SurfaceCard(
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: online ? const Color(0xFF183F32) : Colors.white10, borderRadius: BorderRadius.circular(12)), child: Icon(online ? Icons.wifi : Icons.wifi_off, color: online ? const Color(0xFF64E5A8) : Colors.grey)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(online ? 'Online & siap memindai' : 'Mode offline', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 3),
            Text(online ? 'AI server terhubung • latensi normal' : 'Hanya fitur cache yang tersedia', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
          ])),
          TextButton(onPressed: onScan, child: Text(scanning ? 'STOP' : 'SCAN')),
        ]),
      );

  Widget _sceneCard() => SurfaceCard(child: Row(children: [Container(width: 58, height: 58, decoration: BoxDecoration(color: const Color(0xFF203A3C), borderRadius: BorderRadius.circular(16)), child: Icon(scene == 'Hujan di Kota' ? Icons.grain : Icons.forest, color: const Color(0xFF76D6CF), size: 30)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(scene, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text('Confidence 94%  •  Audio crossfade aktif', style: TextStyle(color: Colors.grey.shade400, fontSize: 12))])), IconButton(onPressed: onToggleAudio, icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_fill, color: const Color(0xFF55DDA0), size: 32))]));
}
