import 'package:flutter/material.dart';

class AppTheme {
  late final ThemeData theme;

  AppTheme() {
    theme = ThemeData(
      appBarTheme: AppBarTheme(
        color: AppColors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      scaffoldBackgroundColor: Colors.white.withOpacity(0.9),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.blueAccent,
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(
          onPrimary: Colors.blue,
          onSecondary: AppColors.blueAccent,
        ),
      ),
      colorScheme: ColorScheme.light(),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.blueAccent),
        side: BorderSide(color: AppColors.blueAccent),
      ),

      textTheme: ThemeData.light().textTheme.copyWith(
        titleLarge: TextStyle(fontSize: 24, color: AppColors.blueAccent),
      ),
    );
  }
}

class AppColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static final Color blueAccent = Colors.blueAccent;
  static final Color green = Colors.green;
  static final Color blue = Colors.blue;
  static final Color grey = Colors.grey;
}
