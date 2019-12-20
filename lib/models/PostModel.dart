import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id, imageUrl, caption, posterId;
  final Timestamp timestamp;
  final dynamic likes;

  PostModel({
    this.id,
    this.imageUrl,
    this.caption,
    this.likes,
    this.posterId,
    this.timestamp,
  });

  factory PostModel.fromDoc(DocumentSnapshot doc) {
    return PostModel(
      id: doc.documentID,
      imageUrl: doc['imageUrl'],
      caption: doc['caption'],
      likes: doc['likes'],
      posterId: doc['posterId'],
      timestamp: doc['timestamp'],
    );
  }
}
