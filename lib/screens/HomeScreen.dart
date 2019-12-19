import 'package:flutter/material.dart';
import 'package:instagram_clone/models/UserData.dart';
import 'package:instagram_clone/screens/ActivityScreen.dart';
import 'package:instagram_clone/screens/CreatePostScreen.dart';
import 'package:instagram_clone/screens/FeedScreen.dart';
import 'package:instagram_clone/screens/ProfileScreen.dart';
import 'package:instagram_clone/screens/SearchScreen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

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
            ProfileScreen(userId: Provider.of<UserData>(context).currentUserId),
          ],
        ),
      ),
    );
  }
}
