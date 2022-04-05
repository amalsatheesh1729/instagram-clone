import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as modeluser;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key,required this.snap}) : super(key: key);

  final snap;
  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    modeluser.user u=Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18,horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilepic']),
           radius: 18,
          ),
          Expanded(
            child: Padding(padding: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [TextSpan(
                        text: '${widget.snap['username']} :      ',
                        style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                      TextSpan(
                          text: widget.snap['text'],
                          style: TextStyle(fontWeight: FontWeight.bold)
                      )
                    ]
                ),),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),style: TextStyle(
                    fontWeight: FontWeight.w400
                  ),),),
              ],
            ),),
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: Icon(Icons.favorite,size: 16),
          )
        ],
      ),
    );
  }
}
