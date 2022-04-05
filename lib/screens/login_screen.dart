import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/Util/colors.dart';
import 'package:instagram_clone/Util/diamensions.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/screens/logup_screen.dart';
import 'package:instagram_clone/widgets/textfield.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Util/utils.dart';
import 'package:instagram_clone/screens/home_screen.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailaddress=TextEditingController();
  TextEditingController _password=TextEditingController();
  bool isloading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailaddress.dispose();
    _password.dispose();
  }

  void login() async
  {
    setState(() {
      isloading=true;
    });
    String res=await  AuthMethod().signInUser(email: _emailaddress.text, password:_password.text);
    setState(() {
      isloading=false;
    });
    if(res=="success") {
      showasnackbar(context, 'SIGNIN Success AYELLO');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ResponsiveLayout(mobileScreenLayout: mobileScreenLayout(), webScreenLayout: webScreenLayout())
      ));
    }
    else {
      showasnackbar(context, res);
    }
  }

  void navigateToSignUp()
  {
   Navigator.push(context, MaterialPageRoute(builder: (context)
   {
    return LogUpScreen();
   }));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
           width: double.infinity,
            padding:(MediaQuery.of(context).size.width)>webScreenSize?
            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3):
            EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/assets/ic_instagram.svg',
              color: primaryColor,
              height: 64,
            ),
            SizedBox(height: 64),
            TextInputField(hintText: 'Enter Email ', controller: _emailaddress, textInputType:TextInputType.emailAddress),
            SizedBox(height: 24),
            TextInputField(hintText: 'Enter Password', controller:_password, textInputType: TextInputType.text,ispass: true),
            SizedBox(height: 24),
            InkWell(
              focusColor: Colors.yellow,
              onTap:login ,
              child:  Container(
                child: isloading?CircularProgressIndicator(
                  color: Colors.yellow,
                ): const Text('Log In'),
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 20,
                ),
                decoration:ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  color: blueColor
                )
              ),
            ),
            SizedBox(height: 50),
            //Flexible(child: Container(),flex: 2),
            Row(
             mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                   padding: EdgeInsets.symmetric(vertical:8),
                    child: Text("Don't have an account?")),
                GestureDetector(
                  onTap: navigateToSignUp,
                  child: Container(
                     padding: EdgeInsets.symmetric(vertical:8),
                      child: Text("Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),)),
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}
