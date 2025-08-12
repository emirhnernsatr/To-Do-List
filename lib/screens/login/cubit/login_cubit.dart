import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_uygulamsi/screens/login/model/login_model.dart';
import 'package:to_do_uygulamsi/screens/login/cubit/login_state.dart';
import 'package:to_do_uygulamsi/core/service/auth_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService;

  LoginCubit(this._authService) : super(const LoginInitial());

  Future<void> login(LoginModel model) async {
    if (model.email.isEmpty || model.password.isEmpty) {
      emit(const LoginError("Lütfen tüm alanları doldurun."));
      return;
    }

    emit(const LoginLoading());

    try {
      final user = await _authService.signInWithEmailAndPassword(
        model.email,
        model.password,
      );

      if (user != null) {
        emit(LoginSuccess("Giriş başarılı! Hoşgeldin: ${user.email}"));
      } else {
        emit(const LoginError("Kullanıcı bulunamadı."));
      }
    } catch (e) {
      emit(LoginError(e.toString().replaceFirst("Exception: ", "")));
    }
  }
}
