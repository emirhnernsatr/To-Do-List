class RegisterModel {
  final String email;
  final String password;
  final String confirmPassword;

  RegisterModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  bool isPasswordConfirmed() => password == confirmPassword;
}
