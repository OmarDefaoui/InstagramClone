import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _fireStore = Firestore.instance;

final usersRef = _fireStore.collection('users');
final storageRef = FirebaseStorage.instance.ref();
final postsRef = _fireStore.collection('posts');
final followersRef = _fireStore.collection('followers');
final followingRef = _fireStore.collection('following');
final feedsRef = _fireStore.collection('feeds');
final likesRef = _fireStore.collection('likes');
final commentsRef = _fireStore.collection('comments');
final activitiesRef = _fireStore.collection('activities');
