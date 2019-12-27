import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/UserData.dart';
import 'package:instagram_clone/models/UserModel.dart';
import 'package:provider/provider.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static Future<bool> signUpUser(BuildContext context, UserModel user) async {
    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.id);
      FirebaseUser signedInUser = _authResult.user;
      if (signedInUser != null) {
        await _firestore
            .collection('/users')
            .document(signedInUser.uid)
            .setData({
          'username': user.username,
          'bio': user.bio,
          'email': user.email,
          'profileImageUrl': user.profileImageUrl,
        });
        Provider.of<UserData>(context).currentUserId = signedInUser.uid;
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<bool> login(
      BuildContext context, String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((error) {
        print('$error');
      });
    } catch (e) {
      print(e);
    }
    return false;
  }

  static void signOut(BuildContext context) {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
