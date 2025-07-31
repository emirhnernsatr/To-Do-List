import 'package:flutter/material.dart';

class AppTheme {
  // açık tema
  static final ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    ),
    scaffoldBackgroundColor: AppColors.white.withOpacity(0.80),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.whitecolor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primaryColor),
      side: BorderSide(color: AppColors.primaryColor),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
      titleLarge: TextStyle(fontSize: 24, color: AppColors.primaryColor),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.blue.withOpacity(0.4),
      selectionHandleColor: AppColors.blue,
      cursorColor: AppColors.primaryColor,
    ),
  );

  //koyu tema
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.chineseblack,
    appBarTheme: AppBarTheme(
      color: AppColors.primaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppColors.white),
      side: const BorderSide(color: AppColors.white70),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.white,
      background: AppColors.chineseblack,
      surface: AppColors.eerieblack,
    ),
    textTheme: ThemeData.dark().textTheme.copyWith(
      titleLarge: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      bodyMedium: const TextStyle(color: Colors.white70),
    ),
    cardColor: AppColors.eerieblack,

    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.blue.withOpacity(0.4),
      selectionHandleColor: AppColors.blue,
      cursorColor: AppColors.primaryColor,
    ),
  );
}

class AppColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static final Color blueAccent = Colors.blueAccent;
  static final Color green = Colors.green;
  static final Color blue = Colors.blue;
  static final Color grey = Colors.grey;
  static final Color primaryColor = Color(0xFF6A4DFF);
  static final Color whitecolor = Color(0xFFF3F4F6);
  static final Color redAccent = Colors.redAccent;
  static final Color onyx = Color(0xFF383838);
  static final Color charlestonGreen = Color(0xFF383838);
  static final Color eerieblack = Color(0xFF1E1E1E);
  static final Color chineseblack = Color(0xFF121212);
}
