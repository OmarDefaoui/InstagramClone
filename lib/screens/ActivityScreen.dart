import 'package:flutter/material.dart';
import 'package:instagram_clone/services/AuthService.dart';

class ActivityScreen extends StatefulWidget {

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: ()=>AuthService.signOut(context),
          child: Text('Sign out'),
        ),
      ),
    );
  }
}