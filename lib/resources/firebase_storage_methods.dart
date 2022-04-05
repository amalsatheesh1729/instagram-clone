import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' ;

class firebaseStorage
{

  FirebaseStorage _firebaseStorage=FirebaseStorage.instance;
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  var uuid=Uuid();

  uploadImageToStorage(String childName,Uint8List file,bool ispost) async
  {
   Reference ref= _firebaseStorage.ref(childName).child(_firebaseAuth.currentUser!.uid);
   String postId=uuid.v1();
   if(ispost)
     {
       ref=ref.child(postId);
     }
    UploadTask uploadTask=ref.putData(file);
    TaskSnapshot taskSnapshot=await uploadTask;
    String downloadurl=await taskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }



}