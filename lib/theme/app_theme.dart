import 'package:flutter/material.dart';

class AppTheme {
  static final Color seedColor = AppColors.primaryColor;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: seedColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white.withOpacity(0.90),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: seedColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.green;
        }
        return seedColor;
      }),
      checkColor: MaterialStateProperty.all<Color>(Colors.white),
      side: BorderSide(color: seedColor),
    ),
    textTheme: Typography.blackMountainView,
    textSelectionTheme: TextSelectionThemeData(
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
    appBarTheme: AppBarTheme(
      backgroundColor: seedColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: seedColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.green;
        }
        return seedColor;
      }),
      checkColor: MaterialStateProperty.all<Color>(Colors.white),
      side: BorderSide(color: seedColor),
    ),
    textTheme: Typography.whiteMountainView,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: seedColor.withOpacity(0.4),
      selectionHandleColor: seedColor,
      cursorColor: seedColor,
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
  static final Color charlestonGreen = Color(0xFF2A2A2A);
  static final Color eerieblack = Color(0xFF1E1E1E);
  static final Color chineseblack = Color(0xFF121212);
}
