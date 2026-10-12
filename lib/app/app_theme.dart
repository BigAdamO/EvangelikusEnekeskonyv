import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const brandBlue = Color(0xFF5499C7);
const deepBlue = Color(0xFF154360);
const paleBlue = Color(0xFFBDC8E3);
const pageColor = Color(0xFFFFFFFF);
const darkPageColor = Color(0xFF393939);

abstract final class AppTheme {
  static ThemeData light(double fontScale) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: deepBlue,
        onPrimary: Colors.white,
        secondary: brandBlue,
        onSecondary: Colors.white,
        tertiary: deepBlue,
        onTertiary: Colors.white,
        primaryContainer: deepBlue,
        onPrimaryContainer: Colors.white,
        secondaryContainer: brandBlue,
        onSecondaryContainer: Colors.white,
        surface: pageColor,
        onSurface: Color(0xFF202124),
        surfaceContainerHighest: paleBlue,
      ),
      scaffoldBackgroundColor: pageColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: deepBlue,
        foregroundColor: Colors.white,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: deepBlue,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: brandBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          shape: const StadiumBorder(),
          textStyle: TextStyle(fontSize: 18 * fontScale),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: paleBlue,
        labelStyle: TextStyle(color: deepBlue),
        floatingLabelStyle: TextStyle(color: deepBlue),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: deepBlue, width: 2),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: deepBlue),
        ),
      ),
    );
  }

  static ThemeData dark(double fontScale) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandBlue,
        brightness: Brightness.dark,
        surface: darkPageColor,
      ),
      scaffoldBackgroundColor: darkPageColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: deepBlue,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: deepBlue,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: brandBlue,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          textStyle: TextStyle(fontSize: 18 * fontScale),
        ),
      ),
    );
  }
}
