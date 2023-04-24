import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class user
{
  final String uid;
  final String username;
  final String bio;
  final String email;
  final String photourl;
  final List followers;
  final List following;

  user({required this.uid,required  this.username,required  this.bio,required  this.email,
    required this.photourl, this.followers=const [],this.following=const []});

  Map<String,dynamic> toJsonMap() {
    return {
      'uid': uid,
      'username': username,
      'bio': bio,
      'email': email,
      'followers': followers,
      'following': following,
      'file': photourl
    };
  }
    static user userfromsnap(DocumentSnapshot snap)
    {
      var snapshot=(snap.data() as Map<String,dynamic>);
      return user(
        uid:snapshot['uid'],
        username: snapshot['username'],
        bio: snapshot['bio'],
        email: snapshot['email'],
        following: snapshot['following'],
        followers: snapshot['followers'],
        photourl:snapshot['file']
      );
    }



}