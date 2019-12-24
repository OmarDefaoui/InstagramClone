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
  BuildContext _context;

  @override
  void initState() {
    super.initState();
    _getScreen();
  }

  _getScreen() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('We have internet');
    } else {
      print('No internet');
    }

    Future.delayed(Duration(seconds: 2), () {
      switch (result) {
        case true:
          Navigator.push(
            _context,
            MaterialPageRoute(builder: (_) => MyApp()),
          );
          break;
        case false:
          Navigator.push(
            _context,
            MaterialPageRoute(builder: (_) => NoInternetScreen()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Icon(
          Icons.home,
          size: 300,
          color: Colors.blue,
        ),
      ),
    );
  }
}
