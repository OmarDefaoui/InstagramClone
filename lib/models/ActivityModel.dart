import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String id;
  final String fromUserId;
  final String postId;
  final String postImageUrl;
  final String comment;
  final Timestamp timestamp;

  ActivityModel({
    this.id,
    this.fromUserId,
    this.postId,
    this.postImageUrl,
    this.comment,
    this.timestamp,
  });

  factory ActivityModel.fromDoc(DocumentSnapshot doc) {
    return ActivityModel(
      id: doc.documentID,
      fromUserId: doc['fromUserId'],
      postId: doc['postId'],
      postImageUrl: doc['postImageUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }
}
