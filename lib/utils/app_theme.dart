import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF26A69A);
  static const Color accentColor = Color(0xFFFF6F00);

  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: const AppBarTheme(elevation: 2, centerTitle: true),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(12),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color(0xFF212121),
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF212121),
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF212121),
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: Color(0xFF424242),
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: Color(0xFF616161),
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF212121),
  );
}
