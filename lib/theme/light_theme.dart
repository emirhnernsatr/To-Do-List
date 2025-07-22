import 'package:flutter/material.dart';

class LightTheme {
  final _lightColor = _LightColor();

  late final ThemeData theme;

  LightTheme() {
    theme = ThemeData(
      appBarTheme: AppBarTheme(
        color: _LightColor().blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      scaffoldBackgroundColor: Colors.white.withOpacity(0.9),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _LightColor().blueAccent,
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(
          onPrimary: Colors.blue,
          onSecondary: _LightColor().blueMenia,
        ),
      ),
      colorScheme: ColorScheme.light(),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(_LightColor().blueAccent),
        side: BorderSide(color: _LightColor().blueAccent),
      ),

      textTheme: ThemeData.light().textTheme.copyWith(
        titleLarge: TextStyle(fontSize: 24, color: _lightColor._textColor),
      ),
    );
  }
}

class _LightColor {
  final Color _textColor = Color.fromARGB(255, 27, 26, 26);
  final Color blueMenia = Color.fromARGB(95, 188, 248, 1);
  final Color blueAccent = Colors.blueAccent;
}
