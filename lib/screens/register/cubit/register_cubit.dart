import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/login/view/login_view.dart';
import 'package:to_do_uygulamsi/screens/register/cubit/register_state.dart';
import 'package:to_do_uygulamsi/screens/register/model/register_model.dart';
import 'package:to_do_uygulamsi/core/service/auth_service.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService _authService;

  RegisterCubit(this._authService) : super(RegisterInitial());

  void register(RegisterModel model, BuildContext context) async {
    if (model.email.isEmpty ||
        model.password.isEmpty ||
        model.confirmPassword.isEmpty) {
      emit(RegisterError("Lütfen tüm alanları doldurun."));
      return;
    }

    if (model.password != model.confirmPassword) {
      emit(RegisterError("Şifreler eşleşmiyor."));
      return;
    }
    emit(RegisterLoading());

    try {
      final user = await _authService.registerWithEmailAndPassword(
        model.email,
        model.password,
      );
      if (user != null) {
        await _authService.signOut();

        emit(RegisterSuccess("Kayıt başarılı. Lütfen giriş yapınız."));

        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      } else {
        emit(RegisterError("Kayıt başarısız. Lütfen tekrar deneyin."));
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(RegisterError(errorMessage));
    }
  }

  void setErrorMessage(String message) {
    emit(RegisterError(message));

    Future.delayed(const Duration(seconds: 3), () {
      emit(RegisterInitial());
    });
  }
}
