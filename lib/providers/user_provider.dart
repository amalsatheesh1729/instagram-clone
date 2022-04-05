import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';
import 'package:instagram_clone/models/user.dart' as modeluser;

class UserProvider with ChangeNotifier
{
  modeluser.user? _user;

  modeluser.user get getUser => _user!;

  Future<void> refreshuser() async
   {
     modeluser.user user=await AuthMethod().userDetails();
     print(user);
     _user=user;
     notifyListeners();
   }
}