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

void showasnackbar (context,String s)
{
   final snackBar = SnackBar(
    content: Text(s),
  );
ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

