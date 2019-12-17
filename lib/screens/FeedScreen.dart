import 'package:flutter/material.dart';
import 'package:instagram_clone/services/AuthService.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'FeedScreen';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: FlatButton(
          child: Text('Log out'),
          onPressed: ()=> AuthService.signOut(context),
        ),
      ),
    );
  }
}
