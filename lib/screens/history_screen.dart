import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import '../widgets/surface_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.onNotifications});
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) => ListView(padding: EdgeInsets.zero, children: [
        AppHeader(title: 'Riwayat', subtitle: 'Transaksi dan aktivitas akun', onNotifications: onNotifications),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [Expanded(child: _metric('3', 'Transaksi')), const SizedBox(width: 10), Expanded(child: _metric('Rp 90k', 'Total pembelian'))])),
        const SizedBox(height: 18),
        ...[
          ['AudiCo PRO • 1 Bulan', '12 Okt 2026', 'Rp 39.000', Icons.workspace_premium],
          ['Forest Adventure Pack', '02 Okt 2026', 'Rp 12.000', Icons.forest],
          ['AudiCo PRO • 1 Bulan', '12 Sep 2026', 'Rp 39.000', Icons.workspace_premium],
        ].map((item) => Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 10), child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), tileColor: const Color(0xFF172323), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), leading: Icon(item[3] as IconData, color: const Color(0xFF63D8A5)), title: Text(item[0] as String, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text(item[1] as String, style: const TextStyle(fontSize: 12)), trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text(item[2] as String), const Text('Berhasil', style: TextStyle(color: Color(0xFF66D9A6), fontSize: 11))])))),
      ]);

  Widget _metric(String value, String label) => SurfaceCard(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF65DDA8))), const SizedBox(height: 3), Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 12))]));
}
