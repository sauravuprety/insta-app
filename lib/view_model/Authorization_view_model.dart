import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/ReadPost_view.dart';

class AuthViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _setUserIdToPreferences(userCredential.user?.uid);

      print('User logged in: ${await _getUserIdFromPreferences()}');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ReadUsers()));
    } catch (e) {
      // Handle login failure
    }
  }

  Future<void> _setUserIdToPreferences(String? userId) async {
    if (userId != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
    }
  }

  Future<String?> _getUserIdFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
}
