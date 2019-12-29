import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/PostModel.dart';
import 'package:instagram_clone/models/UserData.dart';
import 'package:instagram_clone/models/UserModel.dart';
import 'package:instagram_clone/screens/EditProfileScreen.dart';
import 'package:instagram_clone/services/AuthService.dart';
import 'package:instagram_clone/services/FirestoreService.dart';
import 'package:instagram_clone/utilities/Constants.dart';
import 'package:instagram_clone/widgets/PostWidget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String userId;
  ProfileScreen({this.currentUserId, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = true;
  int _followersCount = 0, _followingCount = 0;
  List<PostModel> _posts = [];
  bool _isGrid = true;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
    _setupPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'settings',
                  child: Text('settings'),
                ),
                PopupMenuItem(
                  value: 'rate',
                  child: Text('Rate app'),
                ),
                PopupMenuItem(
                  value: 'share',
                  child: Text('Share app'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              print(value);
              switch (value) {
                case 'logout':
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  AuthService.signOut(context);
                  break;
              }
            },
          ),
        ],
      ),
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
                _buildAllUserInfo(user),
                _buildToggleButtons(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(),
                ),
                _buildUserPosts(user),
              ],
            );
          }),
    );
  }

  Widget _buildAllUserInfo(UserModel user) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        _buildUserData('Posts', _posts.length),
                        _buildUserData('Followers', _followersCount),
                        _buildUserData('Following', _followingCount),
                      ],
                    ),
                    _displayButton(user),
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
              Divider(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30,
          color:
              _isGrid ? Theme.of(context).primaryColor : Colors.grey.shade300,
          onPressed: () {
            if (!_isGrid)
              setState(() {
                _isGrid = true;
              });
          },
        ),
        IconButton(
          icon: Icon(Icons.format_list_bulleted),
          iconSize: 30,
          color:
              !_isGrid ? Theme.of(context).primaryColor : Colors.grey.shade300,
          onPressed: () {
            if (_isGrid)
              setState(() {
                _isGrid = false;
              });
          },
        ),
      ],
    );
  }

  Widget _buildUserPosts(UserModel poster) {
    if (!_isGrid) {
      //Grid
      List<GridTile> tiles = [];
      _posts.forEach((post) {
        tiles.add(GridTile(
          child: Image(
            image: CachedNetworkImageProvider(post.imageUrl),
            fit: BoxFit.cover,
          ),
        ));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      //List
      List<PostWidget> postWidgets = [];
      _posts.forEach((post) {
        postWidgets.add(PostWidget(
          currentUserId: widget.currentUserId,
          post: post,
          poster: poster,
        ));
      });

      return Column(
        children: postWidgets,
      );
    }
  }

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

  _displayButton(UserModel user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
            width: double.infinity,
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(user: user),
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
          )
        : Container(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
            width: double.infinity,
            child: FlatButton(
              onPressed: _followOrUnfollow,
              color: _isFollowing ? Colors.grey.shade300 : Colors.blue,
              child: Text(
                _isFollowing ? 'Following' : 'Follow',
                style: TextStyle(
                  fontSize: 18,
                  color: _isFollowing ? Colors.black : Colors.white,
                ),
              ),
            ),
          );
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await FirestoreService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );

    setState(() {
      _isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int followersCount = await FirestoreService.numFollowers(
      userId: widget.userId,
    );

    setState(() {
      _followersCount = followersCount;
    });
  }

  _setupFollowing() async {
    int followingCount = await FirestoreService.numFollowing(
      userId: widget.userId,
    );

    setState(() {
      _followingCount = followingCount;
    });
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      //unfollow user
      FirestoreService.unFollowUser(
        currentUserId: widget.currentUserId,
        userId: widget.userId,
      );

      setState(() {
        _followersCount--;
        _isFollowing = false;
      });
    } else {
      //follow user
      FirestoreService.followUser(
        currentUserId: widget.currentUserId,
        userId: widget.userId,
      );

      setState(() {
        _followersCount++;
        _isFollowing = true;
      });
    }
  }

  _setupPosts() async {
    List<PostModel> posts = await FirestoreService.getUsersPosts(widget.userId);
    setState(() {
      _posts = posts;
    });
  }
}
