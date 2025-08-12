import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';

class AppSpacing {
  const AppSpacing._();

  static Widget h(double height) => SizedBox(height: height);

  static Widget w(double width) => SizedBox(width: width);
}

class AppPadding {
  const AppPadding._();

  static EdgeInsets all(double value) => EdgeInsets.all(value);

  static EdgeInsets symmetric({double vertical = 0, double horizontal = 0}) =>
      EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}

class AppText {
  static Widget titleText = const Text(
    'To - Do',
    style: TextStyle(
      fontSize: 50,
      color: AppColors.whitecolor,
      fontWeight: FontWeight.bold,
    ),
  );

  static Widget titleHomeText = const Text(
    'Görev Listesi',
    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.whitecolor),
  );

  static Widget forgotMessageText(String message) {
    return Text(
      message,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    );
  }

  static Widget registerText = const Text(
    "Kayıt ol",
    style: TextStyle(
      color: AppColors.whitecolor,
      fontSize: 45,
      fontWeight: FontWeight.bold,
    ),
  );

  static Widget accountPromptText = const Text(
    'Hesabın Var Mı ?',
    style: TextStyle(color: AppColors.white),
  );

  static Widget registerButtonText = const Text(
    'kayıt Ol',
    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
  );

  static Widget forgotPasswordText = const Text(
    'Şifreni mi Unuttun?',
    style: TextStyle(color: AppColors.white70),
  );

  static Widget loginText = const Text(
    'Giriş Yap',
    style: TextStyle(color: AppColors.whitecolor, fontWeight: FontWeight.bold),
  );

  static Widget registerLinkText = const Text(
    'Hesap Oluştur',
    style: TextStyle(color: AppColors.white),
  );

  static Widget titleForgotPasswordText = const Text(
    'Şifre Yenileme',
    style: TextStyle(
      fontSize: 32,
      color: AppColors.whitecolor,
      fontWeight: FontWeight.bold,
    ),
  );

  static Widget noMissionsYetText = const Text('Henüz Görev Yok');

  static Widget taskDetailsText = const Text(
    'Görev Detayı',
    style: TextStyle(color: AppColors.white),
  );

  static Widget addText = const Text(
    'Ekle',
    style: TextStyle(color: AppColors.primaryColor),
  );

  static Widget cancelText = const Text(
    'İptal',
    style: TextStyle(color: AppColors.primaryColor),
  );

  static Widget addNewTaskText = const Text('Yeni Görev Ekle');

  static Widget returnLoginScreenText = const Text(
    'Giriş Ekranına Dön',
    style: TextStyle(color: AppColors.white70),
  );

  static Widget sendResetLinkText = const Text('Sıfırlama Linki Gönder');

  static Widget creationDate = const Text(
    'Olusturulma Tarihi',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  static Widget saveText = const Text(
    'Kaydet',
    style: TextStyle(
      color: AppColors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  );
}
