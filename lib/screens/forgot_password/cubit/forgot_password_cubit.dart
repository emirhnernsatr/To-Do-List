import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/forgot_password_model.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordService _authService;

  ForgotPasswordCubit(this._authService) : super(const ForgotPasswordInitial());

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
      await _authService.sendPasswordResetEmail(model.email);
      // ignore: use_build_context_synchronously
      _showMessage("Şifre sıfırlama bağlantısı gönderildi.", context);
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      // ignore: use_build_context_synchronously
      emit(ForgotPasswordFailure(errorMessage));
    }
  }

  void _showMessage(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class ForgotPasswordService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
