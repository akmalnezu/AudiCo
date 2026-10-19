import 'package:flutter/material.dart';

import '../models/sound_pack.dart';
import '../widgets/app_header.dart';
import '../widgets/surface_card.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key, required this.isPro, required this.onPreview, required this.onPurchase, required this.onUpgrade, required this.onNotifications});
  final bool isPro;
  final Future<void> Function(String title) onPreview;
  final VoidCallback onUpgrade;
  final void Function(SoundPack pack) onPurchase;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) => ListView(padding: EdgeInsets.zero, children: [
        AppHeader(title: 'Marketplace', subtitle: 'Temukan suasana baru untuk ceritamu', onNotifications: onNotifications),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: SurfaceCard(child: Row(children: [Icon(Icons.search, color: Colors.grey), SizedBox(width: 10), Text('Cari sound pack...', style: TextStyle(color: Colors.grey, fontSize: 14))]))),
        const SizedBox(height: 20),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Sound pack pilihan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
        ...SoundPack.catalog.map(_packCard),
        const SizedBox(height: 20),
      ]);

  Widget _packCard(SoundPack pack) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: SurfaceCard(child: Row(children: [
          Container(width: 62, height: 76, decoration: BoxDecoration(color: const Color(0xFF243D3D), borderRadius: BorderRadius.circular(14)), child: Icon(pack.icon, color: const Color(0xFF65D7B0), size: 30)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(pack.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))), if (pack.isPro) _tag('PRO')]),
            const SizedBox(height: 5), Text(pack.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            const SizedBox(height: 10), Row(children: [OutlinedButton.icon(onPressed: () => onPreview(pack.title), icon: const Icon(Icons.play_arrow, size: 16), label: const Text('Preview')), const SizedBox(width: 8), Flexible(child: TextButton(onPressed: () => pack.isPro && !isPro ? onUpgrade() : onPurchase(pack), child: Text(pack.isPro && !isPro ? 'PRO' : pack.price)))])
          ])),
        ])),
      );

  Widget _tag(String text) => Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFB78B35), borderRadius: BorderRadius.circular(6)), child: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)));
}
