import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/HomeScreen.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static Future signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser signedInUser = _authResult.user;
      if (signedInUser != null) {
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'username': name,
          'email': email,
          'profileImageUrl': '',
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  static void login(BuildContext context, String email, String password) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
    } catch (e) {
      print(e);
    }
  }

  static void signOut(BuildContext context) {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
