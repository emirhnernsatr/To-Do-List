abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginRouteState extends LoginState {
  final String uid;
  const LoginRouteState(this.uid);
}

class LoginSuccess extends LoginState {
  final String message;
  LoginSuccess(this.message);
}

class LoginError extends LoginState {
  final String error;
  const LoginError(this.error);
}
