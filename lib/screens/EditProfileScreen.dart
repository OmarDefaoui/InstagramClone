import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/UserModel.dart';
import 'package:instagram_clone/services/FirestoreService.dart';
import 'package:instagram_clone/services/StorageService.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isUploading = false;

  UserModel _userModel;
  String _username, _bio;

  File _profileImage;

  @override
  void initState() {
    super.initState();
    _userModel = widget.user;
    _username = _userModel.username;
    _bio = _userModel.bio;
  }

  void _handkeImageFromGallery() async {
    File _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_imageFile != null) {
      setState(() {
        _profileImage = _imageFile;
      });
    }
  }

  _displayProfileImage() {
    if (_profileImage != null)
      return FileImage(_profileImage);
    else {
      //no new profile image
      if (_userModel.profileImageUrl.trim().isEmpty)
        return AssetImage('assets/images/user_placeholder.jpg');
      else {
        return CachedNetworkImageProvider(_userModel.profileImageUrl);
      }
    }
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isUploading = true;
      });

      String _profileImageUrl = '';
      if (_profileImage == null) {
        _profileImageUrl = _userModel.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
          _userModel.profileImageUrl,
          _profileImage,
        );
      }

      //update datta in db
      UserModel _user = UserModel(
        id: _userModel.id,
        username: _username,
        bio: _bio,
        profileImageUrl: _profileImageUrl,
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isUploading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue.shade200,
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _displayProfileImage(),
                    ),
                    FlatButton(
                      onPressed: _handkeImageFromGallery,
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
          ],
        ),
      ),
    );
  }
}
