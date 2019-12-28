import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/CommentModel.dart';
import 'package:instagram_clone/models/UserData.dart';
import 'package:instagram_clone/models/UserModel.dart';
import 'package:instagram_clone/services/FirestoreService.dart';
import 'package:instagram_clone/utilities/Constants.dart';
import 'package:instagram_clone/utilities/TimeAgo.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  CommentsScreen({this.postId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Comments',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: commentsRef
                .document(widget.postId)
                .collection('postComments')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    CommentModel comment =
                        CommentModel.fromDoc(snapshot.data.documents[index]);
                    return _buildComment(comment);
                  },
                ),
              );
            },
          ),
          Divider(height: 1.0),
          _buildCommentTextField(),
        ],
      ),
    );
  }

  _buildComment(CommentModel comment) {
    return FutureBuilder(
      future: FirestoreService.getUserWithId(comment.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        UserModel author = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey,
            backgroundImage: author.profileImageUrl.isEmpty
                ? AssetImage('assets/images/user_placeholder.jpg')
                : CachedNetworkImageProvider(author.profileImageUrl),
          ),
          title: Text(author.username),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(comment.content),
              SizedBox(height: 6.0),
              Text(
                TimeAgo().format(comment.timestamp.toDate()),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildCommentTextField() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return IconTheme(
      data: IconThemeData(
        color: _isCommenting
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                controller: _commentController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (comment) {
                  setState(() {
                    _isCommenting = comment.length > 0;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Write a comment...'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_isCommenting) {
                    FirestoreService.commentOnPost(
                      currentUserId: currentUserId,
                      postId: widget.postId,
                      comment: _commentController.text,
                    );
                    _commentController.clear();
                    setState(() {
                      _isCommenting = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
