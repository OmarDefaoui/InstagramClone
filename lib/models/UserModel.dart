import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id, username, profileImageUrl, email, bio;

  UserModel({
    this.id,
    this.username,
    this.profileImageUrl,
    this.email,
    this.bio,
  });

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      id: doc.documentID,
      username: doc['username'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      bio: doc['bio'] ?? '',
    );
  }
}
