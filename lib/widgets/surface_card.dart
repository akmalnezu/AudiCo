import 'package:flutter/material.dart';

BoxDecoration audiCoBox() => BoxDecoration(
      color: const Color(0xFF172323),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withValues(alpha: .05)),
    );

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(padding: padding, decoration: audiCoBox(), child: child);
}
