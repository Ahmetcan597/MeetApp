import 'package:appoflutter/BusinessScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';

import '../Entry_Point.dart';


class HumansWidget extends StatefulWidget{
  const HumansWidget({
    super.key,
  });

  // final String distance;
  // final String jobName;
  // final String jobDescription;

  @override
  State<HumansWidget> createState() => _HumansWidgetState();
}

class _HumansWidgetState extends State<HumansWidget> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;


  @override
  void initState() {
    // TODO: implement initState
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
        PageRouteTransition.push(context, const EntryPoint(screen: BusinessScreen(),));
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
      width: 398,
      height: 141,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 2, // Blur radius
              offset: const Offset(0, 3),
            )
          ],
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFFBFEAF5)
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 10,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage("https://monteluke.com.au/wp-content/gallery/linkedin-profile-pictures/9.JPG"),
            ),
          ),
          Positioned(
            top: 5,
            left: 105,
            child: Text('Test',style: TextStyle(fontFamily: "ChalkBoldRe",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.center,),
          ),
          Positioned(
            top: 35,
            left: 105,
            child: Container(
                width: 290,
                //110 characters
                child: Text('Test',style: TextStyle(fontFamily: "ChalkBoldRe",fontSize: 10,color: Color(0xFF707070)),)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 65.0,left: 105),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 46.0,
                aspectRatio: 16/9,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
              items: [1,2,3,4,5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 74,
                          margin: EdgeInsets.only(right: 25.0),
                          decoration: BoxDecoration(
                              color: Colors.amber
                          ),
                        ),
                        Container(
                          width: 74,
                          margin: EdgeInsets.only(right: 25.0),
                          decoration: BoxDecoration(
                              color: Colors.amber
                          ),
                        ),
                        Container(
                          width: 74,
                          margin: EdgeInsets.only(right: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.amber
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 115.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("images/locationicon.png"),
                Text('Test',style: TextStyle(fontFamily: "ChalkBold",fontSize: 14,color: Color(0xFF707070)),textAlign: TextAlign.center,),
                Image.asset("images/eventicon.png"),
                const Text("Available Today",style: TextStyle(fontFamily: "ChalkBold",fontSize: 14,color: Color(0xFF707070)),textAlign: TextAlign.center,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
