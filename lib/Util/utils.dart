import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource s) async
{
  final ImagePicker _imagepicker=ImagePicker();
   XFile? file = await _imagepicker.pickImage(source: s);
   if(file!=null)
     {
      return await file.readAsBytes();
     }
   print('no image selected');

}

void showasnackbar (BuildContext context,String s,Color c)
{
   final snackBar = SnackBar(
     backgroundColor: c,
    content: Text(s),
     duration: Duration(seconds: 2),
  );
ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

