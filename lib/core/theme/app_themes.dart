import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppThemes class containing theme definitions for Professional and Kids modes
class AppThemes {
  // Professional Theme - Dark mode with Glassmorphism elements
  static ThemeData professionalTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    primaryColor: Colors.indigo,
    cardColor: const Color(
      0xFF1E293B,
    ).withValues(alpha: 0.7), // Semi-transparent for glassmorphism
    // Apply Cairo font for Arabic support
    textTheme: GoogleFonts.cairoTextTheme(
      ThemeData.dark().textTheme.copyWith(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        displayMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displaySmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
        titleLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white70,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white60,
        ),
      ),
    ),

    colorScheme: ColorScheme.dark(
      primary: Colors.indigo,
      secondary: Colors.indigoAccent,
      surface: const Color(0xFF1E293B),
    ),
  );

  // Kids Theme - Light mode with playful colors
  static ThemeData kidsTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.orangeAccent,

    // ButtonTheme with rounded corners
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      buttonColor: Colors.orangeAccent,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
    ),

    // Apply Cairo font for Arabic support with playful styling
    textTheme: GoogleFonts.cairoTextTheme(
      ThemeData.light().textTheme.copyWith(
        displayLarge: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.orangeAccent,
        ),
        displayMedium: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.orangeAccent,
        ),
        displaySmall: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: Colors.deepOrange,
        ),
        headlineMedium: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.cyan,
        ),
        headlineSmall: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.cyan,
        ),
        titleLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black54,
        ),
      ),
    ),

    colorScheme: ColorScheme.light(
      primary: Colors.orangeAccent,
      secondary: Colors.cyan,
      surface: Colors.white,
    ),
  );
}
