import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '/Util/diamensions.dart';


class ResponsiveLayout extends StatefulWidget {

  final Widget mobileScreenLayout;
  final Widget webScreenLayout;

  const ResponsiveLayout({Key? key,required this.mobileScreenLayout,required this.webScreenLayout}) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async{
    UserProvider userProvider=Provider.of(context,listen: false);
    await userProvider.refreshuser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints)
    {
      if(constraints.maxWidth<webScreenSize)
        {return widget.mobileScreenLayout;}
          else
       {return  widget.webScreenLayout;}
    });
  }
}
