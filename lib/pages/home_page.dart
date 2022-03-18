import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/pages/my_feed_page.dart';
import 'package:flutter_instagram/pages/my_likes_page.dart';
import 'package:flutter_instagram/pages/my_profile_page.dart';
import 'package:flutter_instagram/pages/my_search_page.dart';
import 'package:flutter_instagram/pages/my_upload_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentTap = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentTap = index;
          });
        },
        children: [
          MyFeedPage(pageController: _pageController),
          MySearchPage(),
          MyUploadPage(pageController: _pageController),
          MyLikesPage(),
          MyProfilePage()
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() {
            _currentTap = index;
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        },
        currentIndex: _currentTap,
        activeColor: const Color.fromRGBO(193, 53, 132, 1),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.add_box)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }
}
