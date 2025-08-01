import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/screens/forgot_password_screen.dart';
import 'package:to_do_uygulamsi/screens/home_screen.dart';
import 'package:to_do_uygulamsi/screens/register_screen.dart';
import 'package:to_do_uygulamsi/service/auth_service.dart';
import 'package:to_do_uygulamsi/theme/app_theme.dart';
import 'package:to_do_uygulamsi/widgets/task_item.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Lütfen e-posta ve şifre giriniz.");
      return;
    }

    try {
      final user = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      if (user != null) {
        _showMessage("Giriş başarılı! Hoşgeldin: ${user.email}");
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
      }
    } catch (e) {
      _showMessage(e.toString());
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
                AppText.TitleText,

                sizedBoxH(70),
                _TextFieldEmail(),

                sizedBoxH(30),
                _TextFieldLoginPassword(),

                sizedBoxH(30),
                _HomeButton(),

                sizedBoxH(20),
                _RegisterButton(context),

                sizedBoxH(20),
                _ForgotPasswordButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton _HomeButton() {
    return TextButton(
      onPressed: _login,
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: AppColors.green,
        ),
        child: Center(child: AppText.LoginText),
      ),
    );
  }

  TextButton _RegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        );
      },
      child: AppText.RegisterLinkText,
    );
  }

  TextButton _ForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
        );
      },
      child: AppText.ForgotPasswordText,
    );
  }

  TextField _TextFieldEmail() {
    return TextField(
      controller: _emailController,
      decoration: customInputDecoration('Email'),
      cursorColor: AppColors.whitecolor,
      style: TextStyle(color: AppColors.whitecolor),
      keyboardType: TextInputType.emailAddress,
    );
  }

  TextField _TextFieldLoginPassword() {
    return TextField(
      controller: _passwordController,
      decoration: customInputDecoration('Sifre'),
      cursorColor: AppColors.whitecolor,
      obscureText: true,
      style: TextStyle(color: AppColors.whitecolor),
    );
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.whitecolor),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.whitecolor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.whitecolor),
      ),
    );
  }
}
