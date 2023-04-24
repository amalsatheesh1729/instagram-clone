import 'dart:math';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as modeluser;
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Util/colors.dart';
import 'package:instagram_clone/Util/utils.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firesbase_firestore_methods.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  bool isloading=false;
  Uint8List? _pic;
  TextEditingController t1=TextEditingController();

  Future<void> postimage(String uid,String username,String userprofileimage) async
  {
    setState(() {
      isloading=!isloading;
    });
  String res= await FirebaseFireStoreStorage().addpost(t1.text, username, uid, userprofileimage, _pic!);
  if(res=="success")
    {
      showasnackbar(context, "Post Addition is Success",Colors.green);
      setState(() {
        _pic=null;
        isloading=!isloading;
      });

    }
  else
    {
      showasnackbar(context,"Post Addition Failed",Colors.red);
      setState(() {
        isloading=!isloading;
        _pic=null;
      });

    }

  }


  _selectImage(BuildContext context)
  {
    return showDialog(context: context, builder: (context)
    {
      return SimpleDialog(
        title: Text('Create a Post'),
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child:Text('Take a Photo'),
            onPressed: () async {
             Navigator.pop(context);
             Uint8List pic=await  pickImage(ImageSource.camera);
             setState(() {
               _pic=pic;
             });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child:Text('Choose from Gallery'),
            onPressed: () async {
              Navigator.pop(context);
              Uint8List pic=await  pickImage(ImageSource.gallery);
              setState(() {
                _pic=pic;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child:Text('Cancel'),
            onPressed: () async {
              Navigator.pop(context);
            },
          )
        ],
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final  modeluser.user user=Provider.of<UserProvider>(context).getUser;

    return _pic==null ?
     Center(
          child: IconButton(
            icon: Icon(Icons.upload), onPressed:()=>_selectImage(context)),
        ): Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: (){
                  setState(() {
                    _pic=null;
                  });;
                },
                icon: Icon(Icons.arrow_back),
              ),
              title: Text('Post To'),
              centerTitle: true,
              actions: [
                TextButton(onPressed:(){
                  postimage(user.uid,user.username,user.photourl);
                }, child: Text('Post'
                  ,style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),))
              ],
            ),
            body: Column(
              children: [
                isloading?LinearProgressIndicator():Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage:NetworkImage(user.photourl) ,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width*0.5,
                        child: TextField(
                          controller: t1,
                          decoration: InputDecoration(
                            hintText: 'Write a caption....',
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
                        )
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(aspectRatio: 487/451,
                        child: Container(
                            decoration:BoxDecoration(
                              image: DecorationImage(image:MemoryImage(_pic!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter
                              ),
                            )
                        ),
                      ),
                    ),
                    Divider()
                  ],
                )
              ],
            )
        );
  }
}
