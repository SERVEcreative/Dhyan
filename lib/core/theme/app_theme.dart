import 'package:flutter/material.dart';

/// Strict black & white palette — low arousal, focus-first (no color dopamine).
abstract final class AppTheme {
  static const Color black = Color(0xFF000000);
  static const Color deepNavy = Color(0xFF000000);
  static const Color background = Color(0xFF0A0A0A);
  static const Color homeCanvas = Color(0xFF000000);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceElevated = Color(0xFF1E1E1E);
  static const Color cardBorder = Color(0xFF3A3A3A);

  /// Semantic aliases — all grayscale for existing widgets.
  static const Color focusBlue = Color(0xFFFFFFFF);
  static const Color clarityTeal = Color(0xFFB8B8B8);
  static const Color restoreGreen = Color(0xFFE0E0E0);
  static const Color softLavender = Color(0xFF8A8A8A);

  static const Color primary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFD4D4D4);
  static const Color accent = Color(0xFFB0B0B0);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF9A9A9A);
  static const Color error = Color(0xFF6B6B6B);
  static const Color success = Color(0xFFE8E8E8);

  static const LinearGradient focusGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF121212), Color(0xFF000000)],
  );

  static const LinearGradient calmCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
  );

  static BoxDecoration homeCardDecoration({Color? borderColor}) => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? cardBorder,
        ),
      );

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        onSurface: textPrimary,
        primary: primary,
        onPrimary: black,
        secondary: secondary,
        tertiary: accent,
        error: error,
        onError: textPrimary,
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: black,
        indicatorColor: surfaceElevated,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? textPrimary : textMuted,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? textPrimary : textMuted);
        }),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: cardBorder),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceElevated,
        selectedColor: surfaceElevated,
        labelStyle: const TextStyle(color: textPrimary),
        side: const BorderSide(color: cardBorder),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: black,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: const BorderSide(color: cardBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: black,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: textPrimary,
        linearTrackColor: surfaceElevated,
        circularTrackColor: surfaceElevated,
      ),
      dividerColor: cardBorder,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: textMuted, fontSize: 14, height: 1.45),
        labelLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: textPrimary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textMuted),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceElevated,
        contentTextStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
