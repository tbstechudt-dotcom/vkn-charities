import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warm, calm palette: cream & peach backgrounds, mocha brown actions,
/// coral highlights.
class AppColors {
  // Core brand
  static const mocha = Color(0xFFA0705F); // primary buttons, brand
  static const mochaDark = Color(0xFF7A5040);
  static const espresso = Color(0xFF2F211C); // footer / top bar
  static const coral = Color(0xFFE9765A); // eyebrows, highlights
  static const peach = Color(0xFFF7DCC4); // blobs, soft fills
  static const apricot = Color(0xFFF0B98A); // decorative lines
  static const cream = Color(0xFFFCF2E8); // hero background
  static const shell = Color(0xFFFAF7F4); // soft card / section fill
  static const band = Color(0xFFA56F5D); // brown feature band

  // Soft icon bubbles
  static const lilac = Color(0xFFEFE3F6);
  static const blush = Color(0xFFFBE3DD);
  static const mist = Color(0xFFE2F0F3);

  // Text & lines
  static const ink = Color(0xFF17171C);
  static const muted = Color(0xFF6E6E78);
  static const line = Color(0xFFEEE6DF);

  // Legacy names used across pages (mapped onto the new palette)
  static const forest = mocha;
  static const forestDark = mochaDark;
  static const sage = blush;
  static const saffron = coral;
  static const saffronLight = cream;
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.mocha,
      primary: AppColors.mocha,
      secondary: AppColors.coral,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  final body = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
    bodyColor: AppColors.ink,
    displayColor: AppColors.ink,
  );
  TextStyle heading(double size, {FontWeight w = FontWeight.w600, double h = 1.22}) =>
      GoogleFonts.poppins(fontSize: size, fontWeight: w, height: h, color: AppColors.ink, letterSpacing: -0.4);

  final buttonText = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14.5);
  final pill = RoundedRectangleBorder(borderRadius: BorderRadius.circular(40));

  return base.copyWith(
    textTheme: body.copyWith(
      displayLarge: heading(54),
      displayMedium: heading(44),
      displaySmall: heading(34),
      headlineMedium: heading(26),
      headlineSmall: heading(19),
      titleLarge: body.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: body.bodyLarge?.copyWith(fontSize: 16, height: 1.75, color: AppColors.muted),
      bodyMedium: body.bodyMedium?.copyWith(fontSize: 14.5, height: 1.7, color: AppColors.muted),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.mocha,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 19),
        shape: pill,
        textStyle: buttonText,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.mocha,
        side: const BorderSide(color: AppColors.mocha, width: 1.3),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 19),
        shape: pill,
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.mocha, textStyle: buttonText),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: pill,
      side: const BorderSide(color: AppColors.line),
      labelStyle: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w500),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.shell,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.mocha, width: 1.5),
      ),
    ),
  );
}
