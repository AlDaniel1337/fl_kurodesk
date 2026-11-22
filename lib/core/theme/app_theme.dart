import 'package:material_ui/material_ui.dart';

class AppTheme {
  AppTheme._();

  // Superficies y fondos
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceElevated = Color(0xFF1C1C1C);
  static const Color surfaceSelected = Color(0xFF222222);

  // Bordes
  static const Color border = Color(0xFF222222);
  static const Color borderSubtle = Color(0xFF2E2E2E);
  static const Color borderActive = Colors.white70;

  // Textos e iconos
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textMuted = Colors.white38;

  // Acentos de estado y cola rotativa
  static const Color statusActive = Colors.greenAccent;
  static const Color queueNextAccent = Color(0xFFFFB74D); // Siguiente en la cola
  static const Color pinnedAccent = Color(0xFF64B5F6);    // Grupo fijado arriba

  // Radios estándar
  static const double radiusWindow = 24.0;
  static const double radiusMini = 23.0;
  static const double radiusPill = 12.0;
  static const double radiusCard = 10.0;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: textPrimary,
        secondary: queueNextAccent,
        outline: borderSubtle,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 34,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        bodyMedium: TextStyle(
          color: textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          color: textSecondary,
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          color: textMuted,
          fontSize: 10,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderSubtle),
        ),
        textStyle: const TextStyle(color: textPrimary, fontSize: 11),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: surfaceSelected,
          foregroundColor: textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusCard),
          ),
        ),
      ),
    );
  }
}