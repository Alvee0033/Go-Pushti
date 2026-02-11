import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Colors ──
  static const Color primary = Color(0xFF00897B); // Teal
  static const Color primaryDark = Color(0xFF00695C);
  static const Color secondary = Color(0xFFFFB300); // Amber
  static const Color secondaryLight = Color(0xFFFFE082);

  // Category accent colors
  static const Color roughageColor = Color(0xFF43A047); // Green
  static const Color concentrateColor = Color(0xFF5C6BC0); // Indigo
  static const Color additiveColor = Color(0xFFFF7043); // Deep Orange
  static const Color resultColor = Color(0xFF00897B); // Teal

  // Semantic
  static const Color met = Color(0xFF66BB6A); // green — requirement met
  static const Color deficit = Color(0xFFEF5350); // red — deficit
  static const Color surfaceCard = Color(0xFFF8F9FA);
  static const Color border = Color(0xFFE0E0E0);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color background = Colors.white;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00897B), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFB300), Color(0xFFFFD54F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient indigoGradient = LinearGradient(
    colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF7043), Color(0xFFFF8A65)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color categoryColor(String category) {
    switch (category) {
      case 'Roughage':
        return roughageColor;
      case 'Concentrate':
        return concentrateColor;
      case 'Additive':
        return additiveColor;
      default:
        return primary;
    }
  }

  static LinearGradient categoryGradient(String category) {
    switch (category) {
      case 'Roughage':
        return greenGradient;
      case 'Concentrate':
        return indigoGradient;
      case 'Additive':
        return orangeGradient;
      default:
        return primaryGradient;
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorSchemeSeed: primary,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        iconTheme: const IconThemeData(color: primary),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 13,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: primary.withValues(alpha: 0.15),
        thumbColor: primary,
        overlayColor: primary.withValues(alpha: 0.12),
        trackHeight: 5,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      ),
    );
  }
}
