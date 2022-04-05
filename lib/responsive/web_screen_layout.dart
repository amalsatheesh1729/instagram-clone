import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Util/colors.dart';
import '../Util/diamensions.dart';


class webScreenLayout extends StatefulWidget {
  const webScreenLayout({Key? key}) : super(key: key);

  @override
  State<webScreenLayout> createState() => _webScreenLayoutState();
}

class _webScreenLayoutState extends State<webScreenLayout> {
  late PageController pageController;

  int _pageindex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController=PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigatetonextpage(int i)
  {
    pageController.jumpToPage(i);
  }

  void onpagechanged(int i)
  {
    setState(() {
      _pageindex=i;
    });
  }

  @override
  Widget build(BuildContext context) {
  return  Padding(
    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/6,right: MediaQuery.of(context).size.width/6),
    child: Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset(
            'lib/assets/ic_instagram.svg',
            color: primaryColor,
            height: 32,
          ),
          actions: [
            IconButton(onPressed:()=> navigatetonextpage(0), icon: Icon(Icons.home,color: _pageindex==0?primaryColor:secondaryColor,)),
            IconButton(onPressed:()=> navigatetonextpage(1), icon: Icon(Icons.search,color: _pageindex==1?primaryColor:secondaryColor,)),
            IconButton(onPressed:()=> navigatetonextpage(2), icon: Icon(Icons.add_a_photo,color: _pageindex==2?primaryColor:secondaryColor,)),
            IconButton(onPressed:()=> navigatetonextpage(3), icon: Icon(Icons.favorite,color: _pageindex==3?primaryColor:secondaryColor,)),
            IconButton(onPressed:()=> navigatetonextpage(4), icon: Icon(Icons.person,color: _pageindex==4?primaryColor:secondaryColor,)),
          ],
        ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children:homescreenitems,
        onPageChanged: onpagechanged,
        controller:pageController ,
      ),
    ),
  );
  }
}
