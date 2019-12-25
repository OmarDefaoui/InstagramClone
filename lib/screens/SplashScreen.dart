import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/errors/NoInternetScreen.dart';
import 'package:instagram_clone/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) {
            _getScreen(context);
            return Center(
              child: Icon(
                Icons.home,
                size: 300,
                color: Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }

  _getScreen(context) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('We have internet');
    } else {
      print('No internet');
    }

    Future.delayed(Duration(seconds: 1), () {
      switch (result) {
        case true:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MyApp()),
            (_) => false,
          );
          break;
        case false:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => NoInternetScreen()),
            (_) => false,
          );
          break;
      }
    });
  }
}
