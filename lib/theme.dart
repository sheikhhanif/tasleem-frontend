// lib/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // 2. Define Light TextTheme
  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: darkCharcoal,
      ),
    ),
    displayMedium: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: darkCharcoal,
      ),
    ),
    displaySmall: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: darkCharcoal,
      ),
    ),
    headlineLarge: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: darkCharcoal,
      ),
    ),
    headlineMedium: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: darkCharcoal,
      ),
    ),
    headlineSmall: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: darkCharcoal,
      ),
    ),
    titleLarge: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: darkCharcoal,
      ),
    ),
    titleMedium: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darkCharcoal,
      ),
    ),
    titleSmall: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: darkCharcoal,
      ),
    ),
    bodyLarge: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: darkCharcoal,
        height: 1.6,
      ),
    ),
    bodyMedium: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: darkCharcoal,
        height: 1.5,
      ),
    ),
    bodySmall: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: darkCharcoal.withOpacity(0.6),
        height: 1.4,
      ),
    ),
    labelLarge: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    labelMedium: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    ),
    labelSmall: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    ),
  );

  // 3. Define Dark TextTheme
  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    displayMedium: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    displaySmall: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    headlineLarge: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    headlineMedium: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    headlineSmall: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    titleLarge: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    titleMedium: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    titleSmall: GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    bodyLarge: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
        height: 1.6,
      ),
    ),
    bodyMedium: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
        height: 1.5,
      ),
    ),
    bodySmall: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.white60,
        height: 1.4,
      ),
    ),
    labelLarge: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    labelMedium: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    ),
    labelSmall: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    ),
  );

  // 4. Define Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Enable Material 3
    brightness: Brightness.light,
    primaryColor: vibrantTeal,
    colorScheme: ColorScheme.fromSeed(
      seedColor: vibrantTeal,
      brightness: Brightness.light,
      primary: vibrantTeal,
      secondary: electricPurple,
      tertiary: brightOrange,
      background: lightGray,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onBackground: darkCharcoal,
      onSurface: darkCharcoal,
    ),
    scaffoldBackgroundColor: lightGray,
    appBarTheme: AppBarTheme(
      backgroundColor: vibrantTeal,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: lightTextTheme,
    iconTheme: IconThemeData(
      color: darkCharcoal.withOpacity(0.6),
      size: 24,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: vibrantTeal,
        foregroundColor: Colors.white,
        textStyle: lightTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
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
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
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
    // Define other theme properties as needed
  );

  // 5. Define Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true, // Enable Material 3
    brightness: Brightness.dark,
    primaryColor: vibrantTeal,
    colorScheme: ColorScheme.fromSeed(
      seedColor: vibrantTeal,
      brightness: Brightness.dark,
      primary: vibrantTeal,
      secondary: electricPurple,
      tertiary: brightOrange,
      background: darkCharcoal,
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: darkCharcoal,
    appBarTheme: AppBarTheme(
      backgroundColor: vibrantTeal,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: darkTextTheme,
    iconTheme: IconThemeData(
      color: Colors.white60,
      size: 24,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: vibrantTeal,
        foregroundColor: Colors.white,
        textStyle: darkTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
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
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
    ),
    cardTheme: CardTheme(
      color: Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: electricPurple,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    // Define other theme properties as needed
  );
}
