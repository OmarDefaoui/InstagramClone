import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/HomeScreen.dart';
import 'package:instagram_clone/screens/LoginScreen.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static Future signUpUser(
      BuildContext context, String name, String email, String password) async {
    showProgressDialog(context);
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
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  static void login(BuildContext context, String email, String password) async {
    showProgressDialog(context);
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  static void signOut(BuildContext context) {
    try {
      _auth.signOut();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginScreen.id, (route) => false);
    } catch (e) {
      print(e);
    }
  }

  static showProgressDialog(BuildContext context) {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(left: 15)),
                  Flexible(
                    flex: 8,
                    child:
                        Text('Please wait...', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }
}
