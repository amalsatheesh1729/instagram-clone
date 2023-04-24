import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../resources/firesbase_firestore_methods.dart';

class ChatMessages extends StatefulWidget {
  ChatMessages({Key? key, required this.recid, required this.recname})
      : super(key: key);
  String recid;
  String recname;

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  TextEditingController t1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.recname),
        centerTitle: true,
        actions: [],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where("msgid", whereIn: [
                    '${FirebaseAuth.instance.currentUser!.uid}${widget.recid}',
                    '${widget.recid}${FirebaseAuth.instance.currentUser!.uid}'
                  ])
                  .orderBy('datetime', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> docsnaps =
                      snapshot.data!.docs;
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        return Align(
                            alignment: docsnaps[i]
                                    .data()['msgid']
                                    .toString()
                                    .startsWith(
                                        FirebaseAuth.instance.currentUser!.uid)
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(20),
                                  shape: BoxShape.rectangle,
                                  color: docsnaps[i]
                                          .data()['msgid']
                                          .toString()
                                          .startsWith(FirebaseAuth
                                              .instance.currentUser!.uid)
                                      ? Colors.purple
                                      : Colors.lightBlue,
                                ),
                                child: Text(docsnaps[i].data()['text'],
                                    style: TextStyle(color: Colors.black))));
                      });
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
        SizedBox(
          height: 50,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Flexible(
            flex: 7,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: t1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                label: Text('Type Your message ',
                    style: TextStyle(color: Colors.white)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: IconButton(
                  onPressed: () async {
                    String x=t1.text;
                    t1.clear();
                    await FirebaseFireStoreStorage.addmessagetobackend(
                      FirebaseAuth.instance.currentUser!.uid,
                      widget.recid,
                      x,
                    );
                  },
                  icon: Icon(Icons.send))),
        ]),
      ]),
    );
  }
}
