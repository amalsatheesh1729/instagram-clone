import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {

  final String hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool ispass;

  const TextInputField({Key? key,required this.hintText,required this.controller
  ,required this.textInputType,this.ispass=false}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final inputborder=OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
    );
    return (TextField(
        decoration:InputDecoration(
            hintText:hintText,
            border: inputborder,
            focusedBorder: inputborder,
            enabledBorder: inputborder,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16)
        ) ,
        obscureText:ispass,
        controller: controller,
        keyboardType:textInputType ,
      ));
  }
}
