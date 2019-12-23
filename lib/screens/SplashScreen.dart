import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasInternet = false;

  _getScreen() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (_hasInternet == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
    }
    setState(() {
      _hasInternet = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(children: <Widget>[
        Center(
          child: Icon(
            Icons.supervisor_account,
            size: 50,
            color: Colors.green,
          ),
        ),
        FutureBuilder(
          future: _getScreen(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (_hasInternet) {
                Timer(Duration(seconds: 3), () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => MyApp()),
                    (_) => false,
                  );
                });

                return MyApp();
              }
              return Center(
                child: Text('No internet'),
              );
            }
          },
        ),
      ]),
    );
  }
}
