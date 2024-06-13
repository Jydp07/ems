import 'package:ems/utils/services/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  final _authService = AuthenticationServices();

  Future<UserCredential> createUser(String email, String password) async {
    return await _authService.createUser(email, password);
  }

  Future<UserCredential> authenticateUser(String email, String password) async {
    return await _authService.authenticateUser(email, password);
  }

  signOut() async {
    return await _authService.signOutUser();
  }

  forgotPassword(String email) async {
    return await _authService.forgotPassword(email);
  }
}
