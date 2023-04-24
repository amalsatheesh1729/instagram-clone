import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Util/diamensions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return  StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            return ListView.builder(
                itemCount: snapshot.data!['notfs'].length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data!['notfs'][i]['profilepic']),
                          radius: 18,
                        ),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: snapshot.data!['notfs'][i]
                                                  ['text'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))
                                        ]),
                                      ),
                                    ]))),
                        Container(
                            padding: EdgeInsets.all(18),
                            child:
                                snapshot.data!['notfs'][i]['icon'].toString() ==
                                        'like'
                                    ? Icon(Icons.favorite,
                                        size: 16, color: Colors.red)
                                    : snapshot.data!['notfs'][i]['icon']
                                                .toString() ==
                                            'comment'
                                        ? Icon(Icons.comment,
                                            size: 16, color: Colors.white)
                                        : Icon(Icons.add,
                                            size: 16, color: Colors.green))
                      ],
                    ),
                  );
                });
          } else {
            return Center(
              child: Text(
                'No Notifications yet ',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        });
  }
}
