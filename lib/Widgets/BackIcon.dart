import 'package:appoflutter/Entry_Point.dart';
import 'package:appoflutter/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({
    super.key, required this.whichScreen,
  });

  final Widget whichScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 20),
        child: GestureDetector(
            onTap: (){
              PageRouteTransition.effect = TransitionEffect.fade;
              PageRouteTransition.push(context, EntryPoint(screen: whichScreen));
            },
            child: Image.asset('images/backicon.png'))
    );
  }
}