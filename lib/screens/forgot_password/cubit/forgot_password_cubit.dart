import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/forgot_password_model.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordService authService;

  ForgotPasswordCubit(this.authService) : super(const ForgotPasswordInitial());

  Future<void> resetPassword(
    ForgotPasswordModel model,
    BuildContext context,
  ) async {
    if (model.email.isEmpty) {
      _showMessage("Lütfen e-posta adresinizi giriniz.", context);
      return;
    }

    emit(const ForgotPasswordLoading());

    try {
      await authService.sendPasswordResetEmail(model.email);
      if (!context.mounted) return;

      emit(
        const ForgotPasswordSuccess("Şifre sıfırlama bağlantısı gönderildi."),
      );
    } catch (e) {
      if (!context.mounted) return;

      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(ForgotPasswordFailure(errorMessage));
    }
  }

  void _showMessage(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
