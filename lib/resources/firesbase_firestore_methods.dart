import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/firebase_storage_methods.dart';


class FirebaseFireStoreStorage
{
  var uuid = Uuid();
  FirebaseFirestore _firestore=FirebaseFirestore.instance;



  Future<String> addpost(String userdescription,String username,String userId,String userprofileimage,Uint8List file) async
  {
    String postId=uuid.v1();
    String res="";
    try{
      _firestore.collection('posts').doc(postId).set(
          post(
              description: userdescription,
              uid: userId,
              likes: [],
              username:username,
              postId: postId,
              datepublished: DateTime.now(),
              profileImage:userprofileimage,
              postPhotoURL: await firebaseStorage().uploadImageToStorage('postimages', file, true)
          ).toJsonMap());
      res="success";
    }
    catch (e)
    {
      res="failure";
    }
return res;
  }

  Future<void> likepost(String postid,String uid,List likes) async
  {
    try{
      if(likes.contains(uid))
        {await _firestore.collection('posts').doc(postid).update({
          'likes':FieldValue.arrayRemove([uid])
        });
        } else {
        await _firestore.collection('posts').doc(postid).update({
          'likes':FieldValue.arrayUnion([uid])
        });}
    }
    catch (e)
    {
      print(e.toString());
    }
  }


  Future<void> postcomment(String postid,String uid,String text,String username,String profilepic) async
  {
  try{
    if(!text.isEmpty)
      {
        String commentId=Uuid().v1();
        await _firestore.collection('posts').doc(postid).collection('comments').doc(commentId).set(
            {
              'profilepic': profilepic,
              'text': text,
              'uid': uid,
              'username':username,
              'commentId':commentId,
              'datePublished':DateTime.now()
            }
        );
      }
    else{
      print('Text is empty');
    }
    }
  catch(e)
    {
     print(e.toString());
    }
  }

  Future<void> deletepost(String postid) async
  {
  try
    {
    await  _firestore.collection('posts').doc(postid).delete();
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  Future<void> followuser(String uid,String followid) async
  {

      DocumentSnapshot<Map<String,dynamic>> snap=await _firestore.collection('users').doc(uid).get();
      List following=snap.data()!['following'];
      print(following);
      if(following.contains(followid))
        {
          await _firestore.collection('users').doc(uid).update(
              {
                'following':FieldValue.arrayRemove([followid])
              });
          await _firestore.collection('users').doc(followid).update(
              {
                'followers':FieldValue.arrayRemove([uid])
              });
        }
      else
        {
          await _firestore.collection('users').doc(uid).update(
              {
                'following':FieldValue.arrayUnion([followid])
              });
          await _firestore.collection('users').doc(followid).update(
              {
                'followers':FieldValue.arrayUnion([uid])
              });
        }
    try{

    }catch(e)
    {
      print(e.toString());
    }
  }

   Future<void> signout() async
   {
    await FirebaseAuth.instance.signOut();
   }

}