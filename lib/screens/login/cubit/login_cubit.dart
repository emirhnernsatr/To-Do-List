import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/home/cubit/home_cubit.dart';
import 'package:to_do_uygulamsi/screens/home/view/home_view.dart';
import 'package:to_do_uygulamsi/screens/login/model/login_model.dart';
import 'package:to_do_uygulamsi/screens/login/cubit/login_state.dart';
import 'package:to_do_uygulamsi/core/service/auth_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService;

  LoginCubit(this._authService) : super(const LoginInitial());

  Future<void> login(LoginModel model, BuildContext context) async {
    if (model.email.isEmpty || model.password.isEmpty) {
      _emitWithAutoClear(const LoginError("Lütfen tüm alanları doldurun."));
      return;
    }

    emit(const LoginLoading());

    try {
      final user = await _authService.signInWithEmailAndPassword(
        model.email,
        model.password,
      );

      if (user != null) {
        _emitWithAutoClear(LoginSuccess("Giriş başarılı! Hoşgeldiniz"));
        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => HomeCubit(user.uid)..listenToTasks(user.uid),
              child: const HomeView(),
            ),
          ),
        );
      } else {
        _emitWithAutoClear(const LoginError("Kullanıcı bulunamadı."));
      }
    } catch (e) {
      _emitWithAutoClear(
        LoginError(e.toString().replaceFirst("Exception: ", "")),
      );
    }
  }

  void _emitWithAutoClear(LoginState state) {
    emit(state);
    Future.delayed(const Duration(seconds: 3), () {
      if (!isClosed) {
        emit(const LoginInitial());
      }
    });
  }
}
