import 'package:flutter/material.dart';

class SoundPack {
  const SoundPack({required this.title, required this.description, required this.price, required this.icon, required this.isPro});

  final String title;
  final String description;
  final String price;
  final IconData icon;
  final bool isPro;

  static const catalog = [
    SoundPack(title: 'Horror Pack', description: 'Bisikan, detak jantung & kegelapan', price: 'Rp 19.000', icon: Icons.nightlight_round, isPro: true),
    SoundPack(title: 'Forest Adventure', description: 'Hutan, burung dan angin lembut', price: 'Rp 12.000', icon: Icons.forest, isPro: false),
    SoundPack(title: 'Action Fantasy', description: 'Pertarungan epik dan energi sihir', price: 'Rp 25.000', icon: Icons.bolt, isPro: true),
  ];
}
