import 'package:flutter/material.dart';

class AppTheme {
  static const Color seedColor = AppColors.primaryColor;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: seedColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      foregroundColor: Colors.white,
    ),
    // ignore: deprecated_member_use
    scaffoldBackgroundColor: Colors.white.withOpacity(0.90),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: seedColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.green;
        }
        return seedColor;
      }),
      checkColor: WidgetStateProperty.all<Color>(Colors.white),
      side: const BorderSide(color: seedColor),
    ),
    textTheme: Typography.blackMountainView,
    textSelectionTheme: TextSelectionThemeData(
      // ignore: deprecated_member_use
      selectionColor: AppColors.blue.withOpacity(0.4),
      selectionHandleColor: AppColors.blue,
      cursorColor: AppColors.blue,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: seedColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: seedColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.green;
        }
        return seedColor;
      }),
      checkColor: WidgetStateProperty.all<Color>(Colors.white),
      side: const BorderSide(color: seedColor),
    ),
    textTheme: Typography.whiteMountainView,
    textSelectionTheme: TextSelectionThemeData(
      // ignore: deprecated_member_use
      selectionColor: AppColors.blue.withOpacity(0.4),
      selectionHandleColor: AppColors.blue,
      cursorColor: AppColors.blue,
    ),
  );
}

class AppColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color blueAccent = Colors.blueAccent;
  static const Color green = Colors.green;
  static const Color greenAccent = Colors.greenAccent;
  static const Color blue = Colors.blue;
  static const Color grey = Colors.grey;
  static const Color primaryColor = Color(0xFF6A4DFF);
  static const Color whitecolor = Color(0xFFF3F4F6);
  static const Color redAccent = Colors.redAccent;
  static const Color onyx = Color(0xFF383838);
  static const Color charlestonGreen = Color(0xFF2A2A2A);
  static const Color eerieblack = Color(0xFF1E1E1E);
  static const Color chineseblack = Color(0xFF121212);
  static const Color white24 = Colors.white24;
}
