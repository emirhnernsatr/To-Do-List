import 'package:flutter/material.dart';

Widget sizedBoxH(double height) => SizedBox(height: height);
//Widget sizedBoxW(double width) => SizedBox(width: width);

class AppColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static final Color blueAccent = Colors.blueAccent;
  static final Color green = Colors.green;
}

class Paddings {
  static const EdgeInsets all50 = EdgeInsets.all(50);
  static const EdgeInsets all40 = EdgeInsets.all(40);
  static const EdgeInsets all16 = EdgeInsets.all(16);
}

class AppText {
  static final TextTitle = Text(
    'To - Do',
    style: TextStyle(
      fontSize: 50,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  );

  static final TextTitleHome = const Text('Görev Listesi');

  static final TextPasswordReset = Text(
    'Şifre Sıfırlama',
    style: TextStyle(
      fontSize: 32,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );

  static final TextForgotMessage = Text(
    '',
    style: TextStyle(color: Colors.white),
    textAlign: TextAlign.center,
  );

  static final TextRegister = Text(
    "Kayıt ol",
    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
  );

  static final AccountPromptText = Text(
    'Hesabın Var Mı ?',
    style: TextStyle(color: AppColors.black),
  );

  static final TextRegisterButton = Text(
    'kayıt Ol',
    style: TextStyle(color: AppColors.white),
  );
}
