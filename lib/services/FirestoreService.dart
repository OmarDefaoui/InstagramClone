import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/UserModel.dart';
import 'package:instagram_clone/utilities/Constants.dart';

class FirestoreService {
  static void updateUser(UserModel user) {
    usersRef.document(user.id).updateData({
      'username': user.username,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        usersRef.where('username', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }
}
