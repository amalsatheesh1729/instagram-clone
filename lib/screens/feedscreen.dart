import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/Util/colors.dart';
import 'package:instagram_clone/widgets/postcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Util/diamensions.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:MediaQuery.of(context).size.width>webScreenSize?null:AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'lib/assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.messenger_outline)),
        ],
      ),
      body:StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){

           if(snapshot.connectionState==ConnectionState.waiting)
             {
               return Center(child: CircularProgressIndicator());
             }
            return ListView.builder(
               itemCount:snapshot.data!.docs.length ,
               itemBuilder: (context,i)
            {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white,width: 10)
                ),
                margin: EdgeInsets.symmetric(
                  horizontal:width>webScreenSize?width/6:0,
                  vertical: width>webScreenSize?15:0
                ),
                child: PostCard(
                  snap:snapshot.data!.docs[i].data()
                ),
              );
            });
          }
      ),
    );
  }
}
