import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Util/colors.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firesbase_firestore_methods.dart';
import 'package:instagram_clone/screens/commentscreen.dart';
import 'package:instagram_clone/screens/resuable_profile_screen.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:instagram_clone/widgets/postcard.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/models/user.dart' as modeluser;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;
  int commentscount=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(context.mounted)
    getcommentcount();
  }

  getcommentcount() async
  {
    QuerySnapshot<Map<String,dynamic>> qs= await FirebaseFirestore.instance.collection('posts').
    doc(widget.snap['postId']).collection('comments').get();
    setState(() {
      commentscount=qs.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    final modeluser.user user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ProfileScreen(uid: widget.snap['uid']);
                      }));
                      },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(widget.snap['profileImage']),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    shrinkWrap: true,
                                    children: ['Delete']
                                        .map(
                                          (e) => InkWell(
                                            onTap: () {
                                              setState(() async{
                                              await  FirebaseFireStoreStorage().deletepost(widget.snap['postId']);
                                              Navigator.of(context).pop();
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ));
                      },
                      icon: Icon(Icons.more_vert))
                ],
              )),
          SizedBox(height: 23),
          GestureDetector(
            onDoubleTap: () async {
              await FirebaseFireStoreStorage().likepost(widget.snap['postId'], user.uid,widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(widget.snap['postPhotoURL'],
                    fit: BoxFit.cover),
              ),
              AnimatedOpacity(
                opacity: isLikeAnimating ? 1 : 0,
                duration: Duration(seconds: 1),
                child: LikeAnimationState(
                  child: Icon(Icons.favorite, color: Colors.white, size: 100),
                  isanimating: isLikeAnimating,
                  duration: const Duration(seconds: 1),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              )
            ]),
          ),
          Row(children: [
             LikeAnimationState(
               isanimating: widget.snap['likes'].contains(user.uid),
               smalllike: true,
               child: IconButton(
                   onPressed: () async{
                     if(!widget.snap['likes'].contains(user.uid))
                       await FirebaseFireStoreStorage().addNotification(widget.snap['uid'],'${user.photourl}','${user.username} liked your post' ,'like');

                     await FirebaseFireStoreStorage().likepost(widget.snap['postId'], user.uid,widget.snap['likes']);
                   },
                   icon: widget.snap['likes'].contains(user.uid)? Icon(Icons.favorite, color:
                   Colors.red) : Icon(Icons.favorite_border)
                ),
             ),
            IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)
              {
                return CommentScreen(snap:widget.snap);
              }));
            }, icon: Icon(Icons.comment_outlined)),
            IconButton(onPressed: () {}, icon: Icon(Icons.send)),
            Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: () {}, icon: Icon(Icons.bookmark_border)),
            ))
          ]),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text('${widget.snap['likes'].length} likes',
                        style: Theme.of(context).textTheme.bodyText2)),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: '${widget.snap['username']}  -  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: widget.snap['description'])
                      ], style: TextStyle(color: primaryColor)),
                    )),
                InkWell(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)
                    {
                      return CommentScreen(snap:widget.snap);
                    }));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'view all ${commentscount.toString()} comments',
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datepublished'].toDate()),
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
