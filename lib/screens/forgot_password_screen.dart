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
                AppText.TitleForgotPasswordText,

                sizedBoxH(40),
                _TextFieldForgotEmail(),

                sizedBoxH(30),
                _ResetPasswordButton(),

                sizedBoxH(20),
                _ReturnLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _ResetPasswordButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryColor,
      ),
      onPressed: _resetPassword,
      child: AppText.SendResetLinkText,
    );
  }

  TextButton _ReturnLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      ),
      child: AppText.ReturnLoginScreenText,
    );
  }

  TextField _TextFieldForgotEmail() {
    return TextField(
      controller: _emailController,
      decoration: _customInputDecoration("Email"),
      cursorColor: AppColors.white,
      style: TextStyle(color: AppColors.white),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _resetPassword(),
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
