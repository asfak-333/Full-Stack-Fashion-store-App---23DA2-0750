import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF7a5136);
  static const Color secondary = Color(0xFF7f552f);
  static const Color tertiary = Color(0xFF6c5649);

  static const Color onPrimary = Color(0xFFffffff);
  static const Color onSecondary = Color(0xFFffffff);
  static const Color onTertiary = Color(0xFFffffff);

  static const Color primaryContainer = Color(0xFF96694c);
  static const Color onPrimaryContainer = Color(0xFFfff9f7);

  static const Color secondaryContainer = Color(0xFFffc697);
  static const Color onSecondaryContainer = Color(0xFF7a512b);

  static const Color tertiaryContainer = Color(0xFF866e60);
  static const Color onTertiaryContainer = Color(0xFFfff8f6);

  static const Color surface = Color(0xFFfff8f4);
  static const Color onSurface = Color(0xFF1f1b16);

  static const Color surfaceVariant = Color(0xFFebe1d8);
  static const Color onSurfaceVariant = Color(0xFF51443d);

  static const Color background = Color(0xFFfff8f4);
  static const Color onBackground = Color(0xFF1f1b16);

  static const Color error = Color(0xFFba1a1a);
  static const Color onError = Color(0xFFffffff);

  static const Color errorContainer = Color(0xFFffdad6);
  static const Color onErrorContainer = Color(0xFF93000a);

  static const Color outline = Color(0xFF83746c);
  static const Color outlineVariant = Color(0xFFd5c3b9);

  // Custom Tailwind colors mapped
  static const Color surfaceContainerHighest = Color(0xFFebe1d8);
  static const Color surfaceContainerHigh = Color(0xFFf1e6dd);
  static const Color surfaceContainer = Color(0xFFf7ece3);
  static const Color surfaceContainerLow = Color(0xFFfdf2e9);
  static const Color surfaceContainerLowest = Color(0xFFffffff);
  static const Color inverseSurface = Color(0xFF352f2a);
  static const Color inverseOnSurface = Color(0xFFfaefe6);
  static const Color inversePrimary = Color(0xFFf2bb99);

  static const Color primaryFixed = Color(0xFFffdbc7);
  static const Color onPrimaryFixed = Color(0xFF301401);

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceContainerHighest,
      ),
      scaffoldBackgroundColor: surface,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w800,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w800,
        ),
        displaySmall: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      useMaterial3: true,
    );
  }
}
