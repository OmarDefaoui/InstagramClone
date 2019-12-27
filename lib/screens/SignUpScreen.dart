import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/UserModel.dart';
import 'package:instagram_clone/services/AuthService.dart';
import 'package:instagram_clone/services/StorageService.dart';

class SignUpScreen extends StatefulWidget {
  static final String id = 'SignUpScreen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username, _bio, _email, _password;
  bool _isPerforming = false;

  File _profileImage;

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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _displayProfileImage(),
                      ),
                      FlatButton(
                        onPressed: _showSelectImageDialog,
                        child: Text(
                          'Change Profile Image',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
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
                          keyboardType: TextInputType.multiline,
                          maxLines: 2,
                          maxLength: 170,
                          decoration: InputDecoration(labelText: 'Bio'),
                          validator: (input) => input.trim().length == 0 ||
                                  input.trim().length > 150
                              ? 'Please enter a valid bio between 0 and 150 character'
                              : null,
                          onSaved: (input) => _bio = input,
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
                        _isPerforming
                            ? Center(child: CircularProgressIndicator())
                            : Container(
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
                        SizedBox(height: 5),
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

  _displayProfileImage() {
    if (_profileImage != null)
      return FileImage(_profileImage);
    else
      return AssetImage('assets/images/user_placeholder.jpg');
  }

  _showSelectImageDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Add photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text('Choose from gallery'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _handleImage(ImageSource source) async {
    Navigator.of(context, rootNavigator: true).pop();
    File imageFile = await ImagePicker.pickImage(source: source);

    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    return croppedImage;
  }

  void _submit() async {
    if (_formKey.currentState.validate() && !_isPerforming) {
      _formKey.currentState.save();
      setState(() {
        _isPerforming = true;
      });

      String _profileImageUrl = '';
      if (_profileImage != null) {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
          '',
          _profileImage,
        );
      }

      print(_username);
      print(_email);
      print(_bio);
      UserModel _user = UserModel(
        username: _username,
        bio: _bio,
        profileImageUrl: _profileImageUrl,
        email: _email,
        id: _password,
      );
      //login user

      bool signupSuccess = await AuthService.signUpUser(context, _user);

      if (!signupSuccess)
        setState(() {
          _isPerforming = false;
        });
    }
  }
}
