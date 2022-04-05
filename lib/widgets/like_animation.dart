import 'package:flutter/material.dart';

class LikeAnimationState extends StatefulWidget {

  final Widget child;
  final bool isanimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smalllike;

  const LikeAnimationState({Key? key,
   required this.child,
   required this.isanimating,
    this.duration=const Duration(seconds: 1),
    this.onEnd,
   this.smalllike=false}) : super(key: key);




  @override
  _LikeAnimationStateState createState() => _LikeAnimationStateState();
}

class _LikeAnimationStateState extends State<LikeAnimationState> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  late Animation<double> scale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController=AnimationController(vsync: this,duration:Duration(seconds:widget.duration.inSeconds));
    scale=Tween<double>(begin:1 ,end:1.2).animate(animationController);
  }

  @override
  void didUpdateWidget(covariant LikeAnimationState oldWidget)  {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.isanimating!=oldWidget.isanimating)
      {
        startAnimation();
      }

  }

   startAnimation() async
   {
     if(widget.isanimating || widget.smalllike)
       {
         await animationController.forward();
         await animationController.reverse();
         await Future.delayed(Duration(seconds: 5));//program execution stops for 5 seconds

         if(widget.onEnd!=null)
           {
             widget.onEnd!();
           }

       }

   }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: scale,
        child: widget.child,
    );
  }



}
