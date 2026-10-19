import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const green = Color(0xFF45D49A);
  static const background = Color(0xFF101A1B);
  static const surface = Color(0xFF172323);

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: green, brightness: Brightness.dark),
        fontFamily: 'Roboto',
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1C2929),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      );
}
