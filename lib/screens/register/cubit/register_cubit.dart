import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/register/cubit/register_state.dart';
import 'package:to_do_uygulamsi/screens/register/model/register_model.dart';
import 'package:to_do_uygulamsi/core/service/auth_service.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService _authService = AuthService();

  RegisterCubit() : super(RegisterInitial());

  void register(RegisterModel model, BuildContext context) async {
    if (model.email.isEmpty ||
        model.password.isEmpty ||
        model.confirmPassword.isEmpty) {
      _emitWithAutoClear(RegisterError("Lütfen tüm alanları doldurun."));
      return;
    }

    if (model.password != model.confirmPassword) {
      _emitWithAutoClear(RegisterError("Şifreler eşleşmiyor."));
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

        _emitWithAutoClear(
          RegisterSuccess("Kayıt başarılı. Lütfen giriş yapınız."),
        );
      } else {
        _emitWithAutoClear(
          RegisterError("Kayıt başarısız. Lütfen tekrar deneyin."),
        );
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      _emitWithAutoClear(RegisterError(errorMessage));
    }
  }

  void _emitWithAutoClear(RegisterState state) {
    emit(state);
    Future.delayed(const Duration(seconds: 3), () {
      if (!isClosed) {
        emit(RegisterInitial());
      }
    });
  }
}
