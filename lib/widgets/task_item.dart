import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/theme/app_theme.dart';

Widget sizedBoxH(double height) => SizedBox(height: height);

//Widget sizedBoxW(double width) => SizedBox(width: width);
class Paddings {
  static const EdgeInsets all50 = EdgeInsets.all(50);
  static const EdgeInsets all40 = EdgeInsets.all(40);
  static const EdgeInsets all16 = EdgeInsets.all(16);
}

class AppText {
  static Widget TitleText = Text(
    'To - Do',
    style: TextStyle(
      fontSize: 50,
      color: AppColors.whitecolor,
      fontWeight: FontWeight.bold,
    ),
  );

  static Widget TitleHomeText = Text(
    'Görev Listesi',
    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.whitecolor),
  );

  static Widget ForgotMessageText(String message) {
    return Text(
      message,
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    );
  }

  static Widget RegisterText = Text(
    "Kayıt ol",
    style: TextStyle(
      color: AppColors.whitecolor,
      fontSize: 45,
      fontWeight: FontWeight.bold,
    ),
  );

  static Widget AccountPromptText = Text(
    'Hesabın Var Mı ?',
    style: TextStyle(color: AppColors.white),
  );

  static Widget RegisterButtonText = Text(
    'kayıt Ol',
    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
  );

  static Widget ForgotPasswordText = Text(
    'Şifreni mi Unuttun?',
    style: TextStyle(color: AppColors.white70),
  );

  static Widget LoginText = Text(
    'Giriş Yap',
    style: TextStyle(color: AppColors.whitecolor, fontWeight: FontWeight.bold),
  );

  static Widget RegisterLinkText = Text(
    'Hesap Oluştur',
    style: TextStyle(color: AppColors.white),
  );

  static Widget TitleForgotPasswordText = Text(
    'Şifre Yenileme',
    style: TextStyle(
      fontSize: 32,
      color: AppColors.whitecolor,
      fontWeight: FontWeight.bold,
    ),
  );

  static Widget NoMissionsYetText = Text('Henüz Görev Yok');

  static Widget TaskDetailsText = Text(
    'Görev Detayı',
    style: TextStyle(color: Colors.white),
  );

  static Widget AddText = Text('Ekle');

  static Widget CancelText = Text('İptal');

  static Widget AddNewTaskText = Text('Yeni Görev Ekle');

  static Widget ReturnLoginScreenText = Text(
    'Giriş Ekranına Dön',
    style: TextStyle(color: AppColors.white70),
  );

  static Widget SendResetLinkText = Text('Sıfırlama Linki Gönder');
}
