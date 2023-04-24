import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Util/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/resuable_profile_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searcheditcontroller = TextEditingController();
  bool ishowusers = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searcheditcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading :false,
          actions: [IconButton(onPressed: (){
            setState(() {
              ishowusers = true;
            });
          }, icon: const Icon(Icons.search))],
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            decoration: const InputDecoration(
                label: Text('Search for user')),
            controller: searcheditcontroller,
            onFieldSubmitted: (String searchtext) {
              setState(() {
                ishowusers = true;
              });
            },
          ),
        ),
        body: ishowusers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searcheditcontroller.text)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
                  if (snap.hasData && snap.data!.size > 0) {
                    return ListView.builder(
                        itemCount: snap.data!.size,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          uid: snap.data!.docs[i]['uid'])));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snap.data!.docs[i]['file']),
                              ),
                              trailing: Text(snap.data!.docs[i]['username']),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
                  if (snap.hasData && snap.data!.size > 0) {
                    final childarr = snap.data!.docs
                        .map(
                          (e) => StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Image.network(e['postPhotoURL']),
                          ),
                        )
                        .toList();
                    return StaggeredGrid.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: childarr);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }));
  }
}
