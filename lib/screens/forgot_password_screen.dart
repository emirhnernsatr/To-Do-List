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

    if (!email.contains('@')) {
      setState(() => message = "Geçerli bir e-posta adresi girin.");
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
        child: SingleChildScrollView(
          child: Padding(
            padding: Paddings.all40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.TitleForgotPasswordText,

                sizedBoxH(20),
                if (message.isNotEmpty) AppText.ForgotMessageText(message),

                sizedBoxH(40),
                _TextFieldForgotEmail(),

                sizedBoxH(30),
                _ResetPasswordButton(),

                sizedBoxH(20),

                sizedBoxH(20),
                _ReturnHomeButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton _ReturnHomeButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: AppText.ReturnLoginScreenText,
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
