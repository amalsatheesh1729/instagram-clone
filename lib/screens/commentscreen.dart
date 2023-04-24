import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Util/colors.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firesbase_firestore_methods.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart' as modeluser;

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key,@required this.snap}) : super(key: key);

  final snap;
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {


  TextEditingController controller=TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    modeluser.user u=Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Comments'),
      ),
      bottomNavigationBar: SafeArea(child:
      Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
       padding: EdgeInsets.only(left: 8,right: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(u.photourl),
              radius: 18,
            ),
            SizedBox(width: 30),
            Expanded(
              child: TextField(
                  controller:controller ,
                  decoration: InputDecoration(hintText: 'Comment as ${u.username}',border: InputBorder.none)
              ),
            ),
            InkWell(
              onTap: () async {
                 await FirebaseFireStoreStorage().postcomment(
                     widget.snap['postId'].toString(),
                     u.uid,
                     controller.text,
                     u.username,
                     u.photourl);
                 setState(() {
                   controller.text="";
                 });
                 await FirebaseFireStoreStorage().addNotification(widget.snap['uid'],'${u.photourl}','${u.username} commented on your post' ,'comment');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                child: Text('POST',style: TextStyle(
                  color: Colors.blueAccent
                ),),
              ),
            )
          ],
        ),
      )
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').orderBy('datePublished',descending: true).snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot)
        {
          if(snapshot.connectionState==ConnectionState.waiting)
            {
              return Center(child: CircularProgressIndicator());
            }
         return ListView.builder(
         itemCount: snapshot.data!.docs.length,
         itemBuilder: (context,i)
         {
           return CommentCard(
             snap: snapshot.data!.docs.elementAt(i),
           );
         });
        }
    ));
  }
}
