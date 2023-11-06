import 'package:appoflutter/Entry_Point.dart';
import 'package:appoflutter/SelectManScreen.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';

import '../LoginScreen.dart';

class JobsWidgets extends StatefulWidget {
  const JobsWidgets({
    Key? key,
    required this.distance,
    required this.money,
    required this.available,
    required this.jobName,
    required this.jobDescription,
    required this.imageLoc,
  }) : super(key: key);

  final String distance;
  final String money;
  final String available;
  final String jobName;
  final String jobDescription;
  final String imageLoc;

  @override
  _JobsWidgetsState createState() => _JobsWidgetsState();
}

class _JobsWidgetsState extends State<JobsWidgets>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.50).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
        PageRouteTransition.effect = TransitionEffect.fade;
        PageRouteTransition.push(context, EntryPoint(screen: SelectManScreen(whichJob: widget.jobName,),));
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: buildContainer(),
          );
        },
      ),
    );
  }

  Container buildContainer() {
    return Container(
      width: 380,
      height: 227,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3),
          )
        ],
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Image.asset(widget.imageLoc,
            height: 156,
            width: 380,
          ),
          Positioned(
            top: 105,
            child: Container(
              width: 380,
              height: 123,
              decoration: BoxDecoration(
                color: Color(0xFFBFEAF5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(height: 10),
                  Text(
                    widget.jobName,
                    style: TextStyle(
                      fontFamily: "ChalkBold",
                      fontSize: 20,
                      color: Color(0xFF707070),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 5),
                  Container(
                    width: 350,
                    child: Text(
                      widget.jobDescription,
                      style: TextStyle(
                        fontFamily: "ChalkBold",
                        fontSize: 10,
                        color: Color(0xFF707070),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(height: 15),
                  Row(
                    children: [
                      Container(width: 70),
                      Image.asset("images/locationicon.png"),
                      Container(width: 5),
                      Text(
                        "${widget.distance} km",
                        style: TextStyle(
                          fontFamily: "ChalkBold",
                          fontSize: 14,
                          color: Color(0xFF707070),
                        ),
                      ),
                      Container(width: 120),
                      // Image.asset("images/pricetagicon.png"),
                      // Container(width: 5),
                      // Text(
                      //   "${widget.money} USD",
                      //   style: TextStyle(
                      //     fontFamily: "ChalkBold",
                      //     fontSize: 14,
                      //     color: Color(0xFF707070),
                      //   ),
                      // ),
                      Image.asset("images/eventicon.png"),
                      Container(width: 5),
                      Container(
                        width: 50,
                        child: Text(
                          "${widget.available} Barber Available Today",
                          style: TextStyle(
                            fontFamily: "ChalkBold",
                            fontSize: 8,
                            color: Color(0xFF707070),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
