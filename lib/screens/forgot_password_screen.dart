import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/screens/login_screen.dart';
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
      _showMessage("Lütfen e-posta adresinizi giriniz.");
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email);
      _showMessage("Şifre sıfırlama bağlantısı gönderildi.");
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      _showMessage(errorMessage);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Padding(
          padding: Paddings.all40,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.titleForgotPasswordText,

                sizedBoxH(40),
                _textFieldForgotEmail(),

                sizedBoxH(30),
                _resetPasswordButton(),

                sizedBoxH(20),
                _returnLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _resetPasswordButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryColor,
      ),
      onPressed: _resetPassword,
      child: AppText.sendResetLinkText,
    );
  }

  TextButton _returnLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      ),
      child: AppText.returnLoginScreenText,
    );
  }

  TextField _textFieldForgotEmail() {
    return TextField(
      controller: _emailController,
      decoration: _customInputDecoration("Email"),
      cursorColor: AppColors.white,
      style: const TextStyle(color: AppColors.white),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _resetPassword(),
    );
  }
}

InputDecoration _customInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.white),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.white),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.white),
    ),
  );
}
