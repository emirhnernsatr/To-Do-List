import 'package:flutter/material.dart';

class AppTheme {
  late final ThemeData theme;

  AppTheme() {
    theme = ThemeData(
      appBarTheme: AppBarTheme(
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      scaffoldBackgroundColor: AppColors.whitecolor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.whitecolor,
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(
          onPrimary: AppColors.primaryColor,
          onSecondary: AppColors.primaryColor,
        ),
      ),
      colorScheme: ColorScheme.light(),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.primaryColor),
        side: BorderSide(color: AppColors.primaryColor),
      ),

      textTheme: ThemeData.light().textTheme.copyWith(
        titleLarge: TextStyle(fontSize: 24, color: AppColors.primaryColor),
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
  static final Color primaryColor = Color(0xFF5C6EF8);
  static final Color whitecolor = Color(0xFFF3F4F6);
}
