import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:instagram_clone/utilities/Constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadUserProfileImage(
      String url, File imageFile) async {
    String pictureId = Uuid().v4();
    File image = await compressImage(pictureId, imageFile, 60);

    if (url.isNotEmpty) {
      //extract already existing pictureId to replace img in firebase
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      pictureId = exp.firstMatch(url)[1];
    }

    StorageUploadTask uploadTask = storageRef
        .child('images/users/userProfile_$pictureId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File> compressImage(
      String pictureId, File image, int quality) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$pictureId.jpg',
      quality: quality,
    );
    return compressedImageFile;
  }

  static Future<String> uploadPost(File imageFile) async {
    String pictureId = Uuid().v4();
    File image = await compressImage(pictureId, imageFile, 70);

    StorageUploadTask uploadTask =
        storageRef.child('images/posts/post_$pictureId.jpg').putFile(image);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
