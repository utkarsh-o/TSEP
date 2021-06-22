import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final _auth = FirebaseAuth.instance;
  loginUser(String email, String password) async {
    final newUser = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return newUser;
  }

  signupUser(String email, String password) async {
    final newUser = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return newUser;
  }

  signoutUser() async {
    _auth.signOut();
  }

  getCurrentUser() async {
    final user = _auth.currentUser;
    return user;
  }

  resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
