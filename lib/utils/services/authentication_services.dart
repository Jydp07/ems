import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> createUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> authenticateUser(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  signOutUser() async {
    return await _auth.signOut();
  }

  forgotPassword(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }
}
