import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/UserModel.dart';
import 'package:instagram_clone/screens/EditProfileScreen.dart';
import 'package:instagram_clone/utilities/Constants.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  ProfileScreen({this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _buildUserData(String title, int value) {
    return Column(
      children: <Widget>[
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: usersRef.document(widget.userId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            UserModel user = UserModel.fromDoc(snapshot.data);
            return ListView(
              children: <Widget>[
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.profileImageUrl.trim().isEmpty
                            ? AssetImage('assets/images/user_placeholder.jpg')
                            : CachedNetworkImageProvider(user.profileImageUrl),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      Expanded(
                    
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _buildUserData('Posts', 23),
                                _buildUserData('Followers', 38),
                                _buildUserData('Following', 45),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                              width: double.infinity,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditProfileScreen(user: user),
                                    ),
                                  );
                                },
                                color: Colors.blue,
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        user.bio,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4),
                        child: Divider(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
