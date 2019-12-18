import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/ActivityScreen.dart';
import 'package:instagram_clone/screens/CreatePostScreen.dart';
import 'package:instagram_clone/screens/FeedScreen.dart';
import 'package:instagram_clone/screens/ProfileScreen.dart';
import 'package:instagram_clone/screens/SearchScreen.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'HomeScreen';
  final String userId;

  HomeScreen({this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Instagram',
            style: TextStyle(
              fontSize: 35,
              color: Colors.black,
              fontFamily: 'Billabong',
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 32),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 32),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera, size: 32),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 32),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 32),
            title: SizedBox.shrink(),
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          onPageChanged: (index) {
            setState(() {
              _currentTab = index;
            });
          },
          controller: _pageController,
          children: <Widget>[
            FeedScreen(),
            SearchScreen(),
            CreatePostScreen(),
            ActivityScreen(),
            ProfileScreen(userId: widget.userId),
          ],
        ),
      ),
    );
  }
}
