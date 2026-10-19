import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.title, this.subtitle, required this.onNotifications});

  final String title;
  final String? subtitle;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: .2)),
            if (subtitle != null) Text(subtitle!, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
          ])),
          IconButton(onPressed: onNotifications, icon: const Icon(Icons.notifications_none_rounded)),
        ]),
      );
}
