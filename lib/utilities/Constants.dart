import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = Firestore.instance;

final usersRef = _fireStore.collection('/users');