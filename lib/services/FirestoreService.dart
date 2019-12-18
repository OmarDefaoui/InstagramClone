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
}
