import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Register Error: ${e.code}');

      String errorMessage = _handleAuthError(e.code);
      _showError(errorMessage);
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Login Error: ${e.code}');

      String errorMessage = _handleAuthError(e.code);
      _showError(errorMessage);
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Reset Password Error: ${e.code}');
      throw _handleAuthError(e.code);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("SignOut Error: $e");
    }
  }
}

String _handleAuthError(String code) {
  switch (code) {
    case 'invalid-email':
      return 'Geçersiz e-posta adresi.';
    case 'user-disabled':
      return 'Bu hesap devre dışı bırakılmış.';
    case 'user-not-found':
      return 'Kullanıcı bulunamadı.';
    case 'wrong-password':
      return 'Hatalı şifre girdiniz.';
    case 'email-already-in-use':
      return 'Bu e-posta adresi zaten kayıtlı.';
    case 'weak-password':
      return 'Şifre çok zayıf. Daha güçlü bir şifre seçin.';
    case 'operation-not-allowed':
      return 'Bu işlem şu anda aktif değil.';
    default:
      return 'Bilinmeyen bir hata oluştu. Lütfen tekrar deneyin.';
  }
}

void _showError(String message) {
  print('Hata: $message');
}
