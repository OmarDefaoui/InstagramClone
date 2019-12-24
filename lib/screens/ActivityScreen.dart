import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/SplashScreen.dart';
import 'package:instagram_clone/services/AuthService.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () => AuthService.signOut(context),
              child: Text('Sign out'),
            ),
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SplashScreen()),
                );
              },
              child: Text('test splash screen'),
            ),
          ],
        ),
      ),
    );
  }
}
