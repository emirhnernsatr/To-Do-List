import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/service/auth_service.dart';
import 'package:to_do_uygulamsi/theme/app_theme.dart';
import 'package:to_do_uygulamsi/widgets/task_item.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();

  String message = '';

  void _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => message = "Lütfen e-posta adresi girin.");
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email);
      setState(() => message = "Şifre sıfırlama bağlantısı gönderildi.");
    } catch (e) {
      setState(() => message = "Hata oluştu: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Padding(
          padding: Paddings.all40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.ForgotMessageText(message),
              sizedBoxH(40),
              _TextFieldForgotEmail(),

              sizedBoxH(30),
              _ResetPasswordButton(),

              sizedBoxH(20),
              AppText.ForgotMessageText(message),

              sizedBoxH(20),
              _ReturnHomeButton(context),
            ],
          ),
        ),
      ),
    );
  }

  TextButton _ReturnHomeButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        "Giriş Ekranına Dön",
        style: TextStyle(color: AppColors.white70),
      ),
    );
  }

  ElevatedButton _ResetPasswordButton() {
    return ElevatedButton(
      onPressed: _resetPassword,
      child: Text("Sıfırlama Linki Gönder"),
    );
  }

  TextField _TextFieldForgotEmail() {
    return TextField(
      controller: _emailController,
      decoration: _customInputDecoration("Email"),
      style: TextStyle(color: AppColors.white),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

InputDecoration _customInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: AppColors.white),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.white),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.white),
    ),
  );
}
