import 'package:firebase_auth/firebase_auth.dart';

class RegistrationViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> registerUser(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // You can handle specific registration errors here
      return null;
    }
  }
}
