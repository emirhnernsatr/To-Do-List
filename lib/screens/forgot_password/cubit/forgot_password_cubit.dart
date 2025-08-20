import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/core/service/auth_service.dart';
import '../model/forgot_password_model.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthService _forgotPasswordService = AuthService();

  ForgotPasswordCubit(ForgotPasswordService forgotPasswordService)
    : super(const ForgotPasswordInitial());

  Future<void> resetPassword(
    ForgotPasswordModel model,
    BuildContext context,
  ) async {
    if (model.email.isEmpty) {
      _emitWithAutoClear(
        const ForgotPasswordFailure("Lütfen e-posta adresinizi giriniz."),
      );
      return;
    }

    _emitWithAutoClear(const ForgotPasswordLoading());

    try {
      await _forgotPasswordService.sendPasswordResetEmail(model.email);

      _emitWithAutoClear(
        const ForgotPasswordSuccess("Şifre sıfırlama bağlantısı gönderildi."),
      );
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      _emitWithAutoClear(ForgotPasswordFailure(errorMessage));
    }
  }

  void _emitWithAutoClear(ForgotPasswordState state) {
    emit(state);
    Future.delayed(const Duration(seconds: 3), () {
      if (!isClosed) {
        emit(const ForgotPasswordInitial());
      }
    });
  }

  void resetState() {
    emit(const ForgotPasswordInitial());
  }
}

class ForgotPasswordService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
