import 'package:flutter/material.dart';
import 'package:instagram_clone/models/PostModel.dart';
import 'package:instagram_clone/models/UserModel.dart';
import 'package:instagram_clone/services/FirestoreService.dart';
import 'package:instagram_clone/widgets/MyAppBar.dart';
import 'package:instagram_clone/widgets/PostWidget.dart';

class FeedScreen extends StatefulWidget {
  final String currentUserId;
  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<PostModel> _posts = [];
  bool noData = false;

  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(),
      body: _posts.length > 0 || noData
          ? RefreshIndicator(
              onRefresh: () => _setupFeed(),
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (BuildContext context, int index) {
                  PostModel post = _posts[index];
                  return FutureBuilder(
                    future: FirestoreService.getUserWithId(post.posterId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserModel poster = snapshot.data;
                        return PostWidget(
                          currentUserId: widget.currentUserId,
                          post: post,
                          poster: poster,
                        );
                      }
                      //returned if noData
                      return SizedBox.shrink();
                    },
                  );
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  _setupFeed() async {
    List<PostModel> posts =
        await FirestoreService.getFeedPosts(widget.currentUserId);
    setState(() {
      (posts.length == 0) ? noData = true : noData = false;
      _posts = posts;
    });
  }
}
