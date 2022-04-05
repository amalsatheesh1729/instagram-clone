import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feedscreen.dart';
import 'package:instagram_clone/screens/resuable_profile_screen.dart';
import 'package:instagram_clone/screens/search-screen.dart';

const int webScreenSize=600;


List<Widget> homescreenitems=[
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text('Thisis page 4')),
  ProfileScreen( uid:FirebaseAuth.instance.currentUser!.uid)
];