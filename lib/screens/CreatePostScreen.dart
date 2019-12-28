import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/PostModel.dart';
import 'package:instagram_clone/models/UserData.dart';
import 'package:instagram_clone/services/FirestoreService.dart';
import 'package:instagram_clone/services/StorageService.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => _submit(),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: _height,
            child: Column(
              children: <Widget>[
                isUploading
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blue.shade200,
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showSelectImageDialog,
                  child: Container(
                    height: _width,
                    width: _width,
                    color: Colors.grey.shade300,
                    child: _image == null
                        ? Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 150,
                          )
                        : Image(
                            image: FileImage(_image),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Caption',
                    ),
                    onChanged: (input) => _caption = input,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        _image = imageFile;
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

  _submit() async {
    if (!isUploading && _image != null && _caption.isNotEmpty) {
      setState(() {
        isUploading = true;
      });

      //upload post
      String imageUrl = await StorageService.uploadPost(_image);
      PostModel post = PostModel(
        imageUrl: imageUrl,
        caption: _caption,
        likeCount: 0,
        posterId: Provider.of<UserData>(context).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      FirestoreService.createPost(post);

      //reset all data
      _captionController.clear();
      FocusScope.of(context).unfocus();
      setState(() {
        _caption = '';
        _image = null;
        isUploading = false;
      });
    }
  }
}
