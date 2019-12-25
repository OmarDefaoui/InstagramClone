import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id, content, authorId;
  final Timestamp timestamp;

  CommentModel({
    this.id,
    this.content,
    this.authorId,
    this.timestamp,
  });

  factory CommentModel.fromDoc(DocumentSnapshot doc) {
    return CommentModel(
      id: doc.documentID,
      content: doc['content'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}
