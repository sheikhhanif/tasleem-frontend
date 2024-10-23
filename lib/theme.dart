// lib/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle

class AppThemes {
  // 1. Define Primary, Secondary, and Accent Colors
  static const Color vibrantTeal = Color(0xFF008080);
  static const Color electricPurple = Color(0xFF6A0DAD);
  static const Color brightOrange = Color(0xFFFFA500);
  static const Color coralPink = Color(0xFFFF6F61);
  static const Color softLavender = Color(0xFFE6E6FA);
  static const Color mintGreen = Color(0xFF98FF98);
  static const Color darkCharcoal = Color(0xFF333333);
  static const Color lightGray = Color(0xFFF5F5F5);

  // 2. Helper Method for Text Styles
  static TextStyle _poppinsStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  static TextStyle _openSansStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
  }) {
    return GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
      ),
    );
  }

  // 3. Define Light TextTheme
  static TextTheme _buildLightTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: _poppinsStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      displayMedium: _poppinsStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      displaySmall: _poppinsStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      headlineLarge: _poppinsStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      headlineMedium: _poppinsStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      headlineSmall: _poppinsStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      titleLarge: _poppinsStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      titleMedium: _poppinsStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      titleSmall: _poppinsStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      bodyLarge: _openSansStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: colorScheme.onBackground,
        height: 1.6,
      ),
      bodyMedium: _openSansStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: colorScheme.onBackground.withOpacity(0.87),
        height: 1.5,
      ),
      bodySmall: _openSansStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: colorScheme.onBackground.withOpacity(0.6),
        height: 1.4,
      ),
      labelLarge: _openSansStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: colorScheme.onPrimary,
      ),
      labelMedium: _openSansStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimary,
      ),
      labelSmall: _openSansStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimary,
      ),
    );
  }

  // 4. Define Dark TextTheme
  static TextTheme _buildDarkTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: _poppinsStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      displayMedium: _poppinsStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      displaySmall: _poppinsStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      headlineLarge: _poppinsStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      headlineMedium: _poppinsStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      headlineSmall: _poppinsStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      titleLarge: _poppinsStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      titleMedium: _poppinsStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      titleSmall: _poppinsStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      bodyLarge: _openSansStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: colorScheme.onBackground.withOpacity(0.87),
        height: 1.6,
      ),
      bodyMedium: _openSansStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: colorScheme.onBackground.withOpacity(0.87),
        height: 1.5,
      ),
      bodySmall: _openSansStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: colorScheme.onBackground.withOpacity(0.6),
        height: 1.4,
      ),
      labelLarge: _openSansStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: colorScheme.onPrimary,
      ),
      labelMedium: _openSansStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimary,
      ),
      labelSmall: _openSansStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimary,
      ),
    );
  }

  // 5. Define Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      primary: vibrantTeal,
      onPrimary: Colors.white,
      secondary: coralPink,
      onSecondary: Colors.white,
      tertiary: brightOrange,
      onTertiary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: lightGray,
      onBackground: darkCharcoal,
      surface: Colors.white,
      onSurface: darkCharcoal,
      brightness: Brightness.light,
      primaryContainer: vibrantTeal, // Using base color since shades are not defined
      secondaryContainer: coralPink,
      tertiaryContainer: brightOrange,
      errorContainer: Colors.red.shade700,
    ),
    scaffoldBackgroundColor: lightGray,
    appBarTheme: AppBarTheme(
      backgroundColor: vibrantTeal,
      elevation: 0,
      titleTextStyle: _poppinsStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    textTheme: _buildLightTextTheme(ColorScheme(
      primary: vibrantTeal,
      onPrimary: Colors.white,
      secondary: coralPink,
      onSecondary: Colors.white,
      tertiary: brightOrange,
      onTertiary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: lightGray,
      onBackground: darkCharcoal,
      surface: Colors.white,
      onSurface: darkCharcoal,
      brightness: Brightness.light,
      primaryContainer: vibrantTeal,
      secondaryContainer: coralPink,
      tertiaryContainer: brightOrange,
      errorContainer: Colors.red.shade700,
    )),
    iconTheme: IconThemeData(
      color: darkCharcoal.withOpacity(0.6),
      size: 24,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: vibrantTeal,
        foregroundColor: Colors.white,
        textStyle: _poppinsStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: vibrantTeal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0.1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: electricPurple,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(electricPurple),
      trackColor: MaterialStateProperty.all(electricPurple.withOpacity(0.5)),
    ),
  );

  // 6. Define Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      primary: vibrantTeal,
      onPrimary: Colors.black,
      secondary: electricPurple,
      onSecondary: Colors.white,
      tertiary: brightOrange,
      onTertiary: Colors.white,
      error: Colors.red.shade400,
      onError: Colors.black,
      background: darkCharcoal,
      onBackground: Colors.white,
      surface: const Color(0xFF1E1E1E),
      onSurface: Colors.white,
      brightness: Brightness.dark,
      primaryContainer: vibrantTeal,
      secondaryContainer: electricPurple,
      tertiaryContainer: brightOrange,
      errorContainer: Colors.red.shade700,
    ),
    scaffoldBackgroundColor: darkCharcoal,
    appBarTheme: AppBarTheme(
      backgroundColor: vibrantTeal,
      elevation: 0,
      titleTextStyle: _poppinsStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    textTheme: _buildDarkTextTheme(ColorScheme(
      primary: vibrantTeal,
      onPrimary: Colors.black,
      secondary: electricPurple,
      onSecondary: Colors.white,
      tertiary: brightOrange,
      onTertiary: Colors.white,
      error: Colors.red.shade400,
      onError: Colors.black,
      background: darkCharcoal,
      onBackground: Colors.white,
      surface: const Color(0xFF1E1E1E),
      onSurface: Colors.white,
      brightness: Brightness.dark,
      primaryContainer: vibrantTeal,
      secondaryContainer: electricPurple,
      tertiaryContainer: brightOrange,
      errorContainer: Colors.red.shade700,
    )),
    iconTheme: IconThemeData(
      color: Colors.white60,
      size: 24,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: vibrantTeal,
        foregroundColor: Colors.white,
        textStyle: _poppinsStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: vibrantTeal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 0.1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: electricPurple,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(electricPurple),
      trackColor: MaterialStateProperty.all(electricPurple.withOpacity(0.5)),
    ),
  );
}
