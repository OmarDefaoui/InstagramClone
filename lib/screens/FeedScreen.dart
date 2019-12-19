import 'package:flutter/material.dart';
import 'package:instagram_clone/services/AuthService.dart';
import 'package:instagram_clone/widgets/MyAppBar.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
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
