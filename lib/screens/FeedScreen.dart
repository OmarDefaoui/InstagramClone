import 'package:flutter/material.dart';
import 'package:instagram_clone/services/AuthService.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: () => AuthService.signOut(context),
          child: Text('sign out'),
          color: Colors.blue,
        ),
      ),
    );
  }
}
