import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/screens/login_screen.dart';
import 'package:to_do_uygulamsi/service/auth_service.dart';
import 'package:to_do_uygulamsi/theme/app_theme.dart';
import 'package:to_do_uygulamsi/widgets/task_item.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final passwordConfirm = _passwordConfirmController.text.trim();

    if (password != passwordConfirm) {
      _showMessage('Şifreler eşleşmiyor.');
      return;
    }

    try {
      final user = await _authService.registerWithEmailAndPassword(
        email,
        password,
      );
      if (user != null) {
        _showMessage('Kayıt başarılı. Giriş yapabilirsiniz.');
        Navigator.pop(context);
      } else {
        _showMessage('Kayıt başarısız. Lütfen tekrar deneyin.');
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      _showMessage(errorMessage);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Padding(
          padding: Paddings.all50,
          child: SingleChildScrollView(
            child: Column(
              children: [
                sizedBoxH(50),
                AppText.RegisterText,

                sizedBoxH(70),
                _TextFieldRegisterEmail(),

                sizedBoxH(30),
                _TextFieldRegisterPassword(),

                sizedBoxH(30),
                _TextFieldRegisterConfirmPassword(),

                sizedBoxH(30),
                _RegisterButton(),

                sizedBoxH(20),
                _AccountPromptButton(context),

                sizedBoxH(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton _RegisterButton() {
    return TextButton(
      onPressed: _register,
      child: Container(
        height: 50,
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.green,
        ),
        child: Center(child: AppText.RegisterButtonText),
      ),
    );
  }

  TextButton _AccountPromptButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      child: AppText.AccountPromptText,
    );
  }

  TextField _TextFieldRegisterEmail() {
    return TextField(
      controller: _emailController,
      decoration: customInputDecoration('Email'),
      style: TextStyle(color: AppColors.white),
      cursorColor: AppColors.white,
    );
  }

  TextField _TextFieldRegisterPassword() {
    return TextField(
      controller: _passwordController,
      decoration: customInputDecoration('Sifre'),
      style: TextStyle(color: AppColors.white),
      cursorColor: AppColors.white,
      obscureText: true,
    );
  }

  TextField _TextFieldRegisterConfirmPassword() {
    return TextField(
      controller: _passwordConfirmController,
      decoration: customInputDecoration('Sifre Onay'),
      style: TextStyle(color: AppColors.white),
      cursorColor: AppColors.white,
      obscureText: true,
    );
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.white),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.white),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.white),
      ),
    );
  }
}
