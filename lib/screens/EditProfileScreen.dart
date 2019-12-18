import 'package:flutter/material.dart';
import 'package:instagram_clone/models/UserModel.dart';
import 'package:instagram_clone/services/FirestoreService.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username, _bio;
  UserModel _userModel;

  @override
  void initState() {
    super.initState();
    _userModel = widget.user;
    _username = _userModel.username;
    _bio = _userModel.bio;
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //update datta in db
      UserModel _user = UserModel(
        id: _userModel.id,
        username: _username,
        bio: _bio,
        profileImageUrl: _userModel.profileImageUrl,
      );
      //db update
      FirestoreService.updateUser(_user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        NetworkImage('https://i.redd.it/dmdqlcdpjlwz.jpg'),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Change Profile Image',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: _username,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, size: 30),
                      labelText: 'Username',
                    ),
                    validator: (input) => input.trim().length < 3
                        ? 'Please enter a valid username'
                        : null,
                    onSaved: (input) => _username = input,
                  ),
                  TextFormField(
                    initialValue: _bio,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, size: 30),
                      labelText: 'Bio',
                    ),
                    validator: (input) => input.trim().length == 0 ||
                            input.trim().length > 150
                        ? 'Please enter a valid bio between 0 and 150 character'
                        : null,
                    onSaved: (input) => _bio = input,
                  ),
                  Container(
                    height: 40,
                    width: 250,
                    margin: EdgeInsets.all(40),
                    child: FlatButton(
                      onPressed: _submit,
                      color: Colors.blue,
                      child: Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
