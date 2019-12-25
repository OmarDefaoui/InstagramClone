import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/main.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
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
            Icon(
              Icons.signal_cellular_connected_no_internet_4_bar,
              size: 300,
              color: Colors.red,
            ),
            FlatButton(
              onPressed: _checkInternet,
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Recheck'),
            ),
          ],
        ),
      ),
    );
  }

  _checkInternet() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MyApp()),
        (_) => false,
      );
      print('We have internet');
    }
  }
}
