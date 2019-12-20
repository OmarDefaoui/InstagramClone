import 'package:flutter/material.dart';

Widget myappbar() {
  return AppBar(
    backgroundColor: Colors.white,
    title: Center(
      child: Text(
        'Instagram',
        style: TextStyle(
          fontSize: 35,
          color: Colors.black,
          fontFamily: 'Billabong',
        ),
      ),
    ),
  );
}
