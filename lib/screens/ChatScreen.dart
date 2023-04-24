import 'package:flutter/material.dart';

import '../Util/diamensions.dart';
import '../resources/Auth_methods.dart';
import 'ChatMessages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getusers();
  }

  getusers() async {
    list = await AuthMethod.getUsers();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('MyChats'),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
            ),
            body: list.isEmpty
                ? Center(child: Text('No Users' ,style: TextStyle(
              color: Colors.white
            ),))
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatMessages(
                                recid: list[i].uid!, recname: list[i].username!);
                          }));
                        },
                        child: ListTile(
                          title: Text(list[i].username!),
                          style: ListTileStyle.list,
                          contentPadding: EdgeInsets.all(30),
                          leading:CircleAvatar(
                              backgroundImage:NetworkImage(list[i].photourl),
                        ))
                      );
                    })));
  }
}
