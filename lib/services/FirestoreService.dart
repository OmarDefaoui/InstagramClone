import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/PostModel.dart';
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

  static void createPost(PostModel post) {
    postsRef.document(post.posterId).collection('userPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likes': post.likes,
      'posterId': post.posterId,
      'timestamp': post.timestamp,
    });
  }

  static void followUser({String currentUserId, String userId}) {
    //add user to current users's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});

    //add current user to user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
  }

  static void unFollowUser({String currentUserId, String userId}) {
    //remove user from current users's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) doc.reference.delete();
    });

    //remove current user from user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) doc.reference.delete();
    });
  }

  static Future<bool> isFollowingUser(
      {String currentUserId, String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();

    return followingDoc.exists;
  }

  static Future<int> numFollowers({String userId}) async {
    QuerySnapshot followersSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();

    return followersSnapshot.documents.length;
  }

  static Future<int> numFollowing({String userId}) async {
    QuerySnapshot followingSnapshot = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();

    return followingSnapshot.documents.length;
  }
}
