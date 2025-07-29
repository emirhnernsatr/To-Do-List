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

  String message = '';

  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final passwordConfrim = _passwordConfirmController.text.trim();

    if (password != passwordConfrim) {
      setState(() {
        message = 'Şifreler eşleşmiyor';
      });
      return;
    }

    final user = await _authService.registerWithEmailAndPassword(
      email,
      password,
    );
    setState(() {
      if (user != null) {
        message = 'Kayıt başarılı! Hoşgeldin: ${user.email}';
        Navigator.pop(context);
      } else {
        message = 'Kayıt başarısız!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Padding(
          padding: Paddings.all50,
          child: Column(
            children: [
              sizedBoxH(50),
              Container(child: AppText.RegisterText),

              sizedBoxH(70),
              Column(
                children: [
                  _TextFieldRegisterEmail(),
                  sizedBoxH(20),

                  _TextFieldRegisterPassword(),
                  sizedBoxH(20),

                  _TextFieldRegisterConfirmPassword(),
                ],
              ),
              sizedBoxH(30),
              Center(child: _RegisterButton()),

              sizedBoxH(20),
              Center(child: _AccountPromptButton(context)),
              sizedBoxH(20),

              Text(message),
            ],
          ),
        ),
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

  TextField _TextFieldRegisterConfirmPassword() {
    return TextField(
      controller: _passwordConfirmController,
      decoration: customInputDecoration('Sifre Onay'),
      obscureText: true,
    );
  }

  TextField _TextFieldRegisterPassword() {
    return TextField(
      controller: _passwordController,
      decoration: customInputDecoration('Sifre'),
      obscureText: true,
    );
  }

  TextField _TextFieldRegisterEmail() {
    return TextField(
      controller: _emailController,
      decoration: customInputDecoration('Email'),
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
