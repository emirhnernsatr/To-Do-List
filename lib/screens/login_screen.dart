import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/screens/home_screen.dart';
import 'package:to_do_uygulamsi/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                child: Text(
                  "To - Do ",
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 70),
              Column(
                children: [
                  TextField(decoration: customInputDecoration('Kullanıcı Adı')),
                ],
              ),
              SizedBox(height: 30),
              TextField(decoration: customInputDecoration('Sifre')),
              SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'sifremi Unuttum',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Text(
                        'Giris Yap',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Hesap Olustur',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }
}
