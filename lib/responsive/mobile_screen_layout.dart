import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Util/diamensions.dart';
import 'package:instagram_clone/Util/colors.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '/screens/login_screen.dart';
import 'package:instagram_clone/screens/logup_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';

class mobileScreenLayout extends StatefulWidget {
  const mobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<mobileScreenLayout> createState() => _mobileScreenLayoutState();
}

class _mobileScreenLayoutState extends State<mobileScreenLayout> {


late PageController pageController;
int _pageindex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController=PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

 void navigatetonextpage(int i)
 {
pageController.jumpToPage(i);
 }

 void onpagechanged(int i)
 {
  setState(() {
    _pageindex=i;
  });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children:homescreenitems,
        onPageChanged: onpagechanged,
        controller:pageController ,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: navigatetonextpage,
          currentIndex: _pageindex,
          items: [
        BottomNavigationBarItem(
          backgroundColor:Colors.yellow,
            icon: Icon(Icons.home, color:_pageindex==0?Colors.blueAccent:Colors.black),
            label : 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.search), label: 'Search',
            backgroundColor:Colors.teal),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_circle), label: 'Add Post',
        backgroundColor: Colors.red),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), label: 'Like',
        backgroundColor: Colors.orange),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'Account',
        backgroundColor: Colors.brown)
      ]),
    );
  }
}
