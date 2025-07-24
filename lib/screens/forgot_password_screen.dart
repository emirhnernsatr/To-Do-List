import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/service/auth_service.dart';

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
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Şifre Sıfırlama',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: _customInputDecoration("Email"),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text("Sıfırlama Linki Gönder"),
              ),
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Giriş Ekranına Dön",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _customInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.white54),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white70),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}
