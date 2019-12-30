import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/ActivityModel.dart';
import 'package:instagram_clone/models/PostModel.dart';
import 'package:instagram_clone/models/UserData.dart';
import 'package:instagram_clone/models/UserModel.dart';
import 'package:instagram_clone/services/FirestoreService.dart';
import 'package:instagram_clone/utilities/TimeAgo.dart';
import 'package:provider/provider.dart';

import 'CommentsScreen.dart';

class ActivityScreen extends StatefulWidget {
  final String currentUserId;
  ActivityScreen({this.currentUserId});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<ActivityModel> _activities = [];

  @override
  void initState() {
    super.initState();
    _setupActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Activity',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _setupActivities(),
        child: ListView.builder(
          itemCount: _activities.length,
          itemBuilder: (BuildContext context, int index) {
            ActivityModel activity = _activities[index];
            return _buildActivity(activity);
          },
        ),
      ),
    );
  }

  _setupActivities() async {
    List<ActivityModel> activities =
        await FirestoreService.getActivities(widget.currentUserId);
    if (mounted) {
      setState(() {
        _activities = activities;
      });
    }
  }

  _buildActivity(ActivityModel activity) {
    return FutureBuilder(
      future: FirestoreService.getUserWithId(activity.fromUserId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        UserModel user = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey,
            backgroundImage: user.profileImageUrl.isEmpty
                ? AssetImage('assets/images/user_placeholder.jpg')
                : CachedNetworkImageProvider(user.profileImageUrl),
          ),
          title: activity.comment != null
              ? Text('${user.username} commented: "${activity.comment}"')
              : Text('${user.username} liked your post'),
          subtitle: Text(
            TimeAgo().format(activity.timestamp.toDate()).toString(),
          ),
          trailing: CachedNetworkImage(
            imageUrl: activity.postImageUrl,
            height: 40.0,
            width: 40.0,
            fit: BoxFit.cover,
          ),
          onTap: () async {
            String currentUserId = Provider.of<UserData>(context).currentUserId;
            PostModel post = await FirestoreService.getUserPost(
              currentUserId,
              activity.postId,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommentsScreen(
                  post: post,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
