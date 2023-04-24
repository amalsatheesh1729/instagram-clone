import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/Util/colors.dart';
import 'package:instagram_clone/Util/utils.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/widgets/textfield.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';
import 'package:image_picker/image_picker.dart';
import '../Util/diamensions.dart';
import '../main.dart';

class LogUpScreen extends StatefulWidget {
  const LogUpScreen({Key? key}) : super(key: key);

  @override
  _LogUpScreenState createState() => _LogUpScreenState();
}

class _LogUpScreenState extends State<LogUpScreen> {
  TextEditingController _emailaddress = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _bio = TextEditingController();
  Uint8List? image;
  bool isloading = false;

  void initializeimg() async {
    final response = await http.get(Uri.parse('https://st3.depositphotos.com'
        '/15648834/17930/v/1600/depositphotos_179308454-stock-illustration-'
        'unknown-person-silhouette-glasses-profile.jpg'));
    setState(() {
      image = response.bodyBytes;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeimg();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailaddress.dispose();
    _password.dispose();
    _username.dispose();
    _bio.dispose();
  }

  imagepicking() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  void LogUp() async {
    setState(() {
      isloading = true;
    });
    await AuthMethod().signout();
    String res = await AuthMethod().signUpUser(
        email: _emailaddress.text,
        password: _password.text,
        username: _username.text,
        bio: _bio.text,
        file: image!);
    if (res == "success") {
      showasnackbar(context, 'SignUp is succesful !!', Colors.green);
     navigateToSignIn();
    } else {
      showasnackbar(context, 'SignUp has failed ', Colors.red);
    }
    setState(() {
      isloading = false;
    });
  }

  void navigateToSignIn() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width / 6 : width / 20,
                vertical: width > webScreenSize ? 15 : width / 11),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: SvgPicture.asset(
                    'lib/assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                ),
                SizedBox(height: 64),
                Flexible(
                  flex: 2,
                  child: Stack(
                    children: [
                      image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(image!),
                            )
                          : CircularProgressIndicator(),
                      Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                              onPressed: imagepicking,
                              icon: Icon(
                                Icons.add_a_photo,
                              )))
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Flexible(
                    flex: 2,
                    child: TextInputField(
                        hintText: 'Enter Username ',
                        controller: _username,
                        textInputType: TextInputType.text)),
                SizedBox(height: 24),
                Flexible(
                    flex: 2,
                    child: TextInputField(
                        hintText: 'Enter Email ',
                        controller: _emailaddress,
                        textInputType: TextInputType.emailAddress)),
                SizedBox(height: 24),
                Flexible(
                    flex: 2,
                    child: TextInputField(
                        hintText: 'Enter Password',
                        controller: _password,
                        textInputType: TextInputType.text,
                        ispass: true)),
                SizedBox(height: 24),
                Flexible(
                    flex: 2,
                    child: TextInputField(
                        hintText: 'Enter Bio',
                        controller: _bio,
                        textInputType: TextInputType.text)),
                SizedBox(height: 24),
                Flexible(
                  fit: FlexFit.tight,
                  child: InkWell(
                    focusColor: Colors.yellow,
                    onTap: LogUp,
                    child: isloading?CircularProgressIndicator():Container(
                        child: const Text('Log Up'),
                        width: double.infinity,
                        alignment: Alignment.center,
                        //padding: EdgeInsets.symmetric(vertical: 20,
                        //),
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            color: blueColor)),
                  ),
                ),
                SizedBox(height: 34),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("Already have an account?")),
                      GestureDetector(
                        onTap: navigateToSignIn,
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Sign In",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
