import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {

  final Function()? fun;
  final Color bgcolor;
  final Color bordercolor;
  final Color textcolor;
  final String text;

  const FollowButton({Key? key,
    this.fun,
    required this.bgcolor,
    required this.bordercolor,
    required this.text,
    required this.textcolor}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: TextButton(onPressed:fun, child:Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: bordercolor,
        ),
        borderRadius: BorderRadius.circular(5)
      ),
        alignment:Alignment.center,
        child: Text(text,
          style: TextStyle(
            color: textcolor,
              fontWeight: FontWeight.bold
          ),
        ),
        width: 200,
        height: 20,
      ) )
    );
  }
}
