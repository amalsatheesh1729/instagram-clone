import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Util/colors.dart';
import 'package:instagram_clone/Util/utils.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

import '../Util/diamensions.dart';
import '../resources/firesbase_firestore_methods.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> docsnap = {};
  int postcount = 0;
  int followers = 0;
  int following = 0;
  bool isfollowing = false;
  bool isloading = true;

  getdata() async {
    try {
      //user
      DocumentSnapshot<Map<String, dynamic>> documentSnapshotsnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .get();
      docsnap = documentSnapshotsnapshot.data()!;
      //post
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('uid', isEqualTo: docsnap['uid'])
              .get();
      postcount = querySnapshot.docs.length;
      following = docsnap['following'].length;
      followers = docsnap['followers'].length;
      isfollowing =
          docsnap['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      isloading = false;
      setState(() {});
    } catch (e) {
      showasnackbar(context, e.toString(),Colors.red);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(widget.uid);
    return isloading
        ? Center(
            child: CircularProgressIndicator(
            value: 10,
            color: Colors.red,
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
                automaticallyImplyLeading : false,
            ),
            body: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Row(children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(docsnap['file']),
                          radius: 40,
                          backgroundColor: Colors.grey,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildstackcolumn(postcount, 'posts'),
                                  SizedBox(width: 7),
                                  buildstackcolumn(followers, 'followers'),
                                  SizedBox(width: 7),
                                  buildstackcolumn(following, 'following'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.uid ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? FollowButton(
                                          bgcolor: mobileBackgroundColor,
                                          bordercolor: Colors.grey,
                                          text: 'Sign out',
                                          textcolor: primaryColor,
                                          fun: () async {
                                            await AuthMethod()
                                                .signout();
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return LoginScreen();
                                            }));
                                          })
                                      : isfollowing == true
                                          ? FollowButton(
                                              bgcolor: Colors.white,
                                              bordercolor: Colors.grey,
                                              text: 'Unfollow',
                                              textcolor: Colors.white,
                                              fun: () async {
                                                await FirebaseFireStoreStorage()
                                                    .followuser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        widget.uid);
                                                setState(() {
                                                  isfollowing = false;
                                                  followers--;
                                                });
                                              },
                                            )
                                          : FollowButton(
                                              bgcolor: Colors.blue,
                                              bordercolor: Colors.grey,
                                              text: 'Follow',
                                              textcolor: Colors.white,
                                              fun: () async {
                                                await FirebaseFireStoreStorage()
                                                    .followuser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        widget.uid);
                                                setState(() {
                                                  isfollowing = true;
                                                  followers++;
                                                });
                                              },
                                            ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ]),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          docsnap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 1),
                        child: Text(
                          docsnap['bio'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ])),
                Divider(thickness: 5),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            qsnap) {
                      if (!qsnap.hasData) {
                        return CircularProgressIndicator();
                      }

                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: qsnap.data!.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  crossAxisCount: 3,
                                  childAspectRatio: 1),
                          itemBuilder: (context, index) {
                            return Container(
                              child: Image(
                                image: NetworkImage(
                                    qsnap.data!.docs[index]['postPhotoURL']),
                                fit: BoxFit.cover,
                              ),
                            );
                          });
                    })
              ],
            ));
  }

  Column buildstackcolumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        )
      ],
    );
  }
}
