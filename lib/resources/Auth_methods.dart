//import 'dart:html';
import 'dart:typed_data';
import 'firebase_storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as modeluser;

class AuthMethod
{

  final FirebaseAuth _auth =FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  dynamic signUpUser ({
  required String email,required String password,required String username,
    required String bio,required Uint8List file}) async
  {
    String res="success";
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String photourl = await firebaseStorage().
      uploadImageToStorage("PhotoURL", file, false);

      modeluser.user user=modeluser.user(uid:uc.user!.uid,
        username: username,bio:bio,email: email,photourl: photourl,followers: [],
      following: []);

      _firestore.collection('users').doc(uc.user?.uid).set(user.toJsonMap());
    }
    catch (e) {
      return e.toString();
    }
    return res;
  }

  dynamic signInUser({required String email,required String password}) async
  {
    String res="success";
    try {
      UserCredential uc = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      res="success";
    }
    catch(e)
    {
      res=e.toString();
    }
   return res;
  }

   Future<modeluser.user>  userDetails() async
    {
     User fireuser=_auth.currentUser!;

     DocumentSnapshot snap=await _firestore.collection('users').doc(fireuser.uid).get();
     return   modeluser.user.userfromsnap(snap);

    }


}
