import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/register/cubit/register_state.dart';
import 'package:to_do_uygulamsi/screens/register/model/register_model.dart';
import 'package:to_do_uygulamsi/core/service/auth_service.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService _authService;

  RegisterCubit(this._authService) : super(RegisterInitial());

  void register(RegisterModel model, BuildContext context) async {
    if (model.password != model.confirmPassword) {
      _showMessage('Şifreler eşleşmiyor.', context);
      return;
    }

    try {
      final user = await _authService.registerWithEmailAndPassword(
        model.email,
        model.password,
      );
      if (user != null) {
        // ignore: use_build_context_synchronously
        _showMessage('Kayıt başarılı. Giriş yapabilirsiniz.', context);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        _showMessage('Kayıt başarısız. Lütfen tekrar deneyin.', context);
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      // ignore: use_build_context_synchronously
      _showMessage(errorMessage, context);
    }
  }

  void _showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
