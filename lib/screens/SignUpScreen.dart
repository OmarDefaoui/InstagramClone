import 'package:flutter/material.dart';
import 'package:instagram_clone/services/AuthService.dart';

class SignUpScreen extends StatefulWidget {
  static final String id = 'SignUpScreen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username, _email, _password;

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_username);
      print(_email);
      print(_password);
      //login user

      AuthService.signUpUser(context, _username, _email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Instagram',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'Billabong',
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Username'),
                          validator: (input) => input.length < 4
                              ? 'Must be at least 4 characters'
                              : null,
                          onSaved: (input) => _username = input,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (input) => !input.contains('@')
                              ? 'Please enter a valid email'
                              : null,
                          onSaved: (input) => _email = input.trim(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          validator: (input) => input.length < 8
                              ? 'Must be at least 8 characters'
                              : null,
                          onSaved: (input) => _password = input,
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 250,
                          child: FlatButton(
                            padding: EdgeInsets.all(10),
                            onPressed: _submit,
                            color: Colors.blue,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 250,
                          child: FlatButton(
                            padding: EdgeInsets.all(10),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.blue,
                            child: Text(
                              'Back to login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
