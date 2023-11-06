import 'package:appoflutter/Entry_Point.dart';
import 'package:appoflutter/GiveServiceScreen.dart';
import 'package:appoflutter/Widgets/HumansWidget.dart';
import 'package:appoflutter/Widgets/ProfileButton.dart';
import 'package:appoflutter/Widgets/TopSide.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';

import 'Widgets/JobsWidgets.dart';

class YourServicesScreen extends StatefulWidget {
  const YourServicesScreen({Key? key}) : super(key: key);

  @override
  State<YourServicesScreen> createState() => _YourServicesScreenState();
}

class _YourServicesScreenState extends State<YourServicesScreen> {
  @override
  Widget build(BuildContext context) {

    final currentHeight = MediaQuery.of(context).size.height.round();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFEAFDFC),
        body: Column(
          children: [
            Container(height: 8,),
            TopSide(),
            Container(height: currentHeight / 89,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Your Services",style: TextStyle(fontFamily: "ChalkBold",fontSize: 25,color: Color(0xFF707070)),textAlign: TextAlign.center,),
              ],
            ),
            Container(height: currentHeight / 89,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50)
              ),
              height: currentHeight / 1.78,
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                        margin: EdgeInsets.only(bottom: 30),
                          child: Center(
                              child: HumansWidget(),
                    ),
                  );
                }
              ),
            ),
            Container(height: currentHeight / 29.6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    PageRouteTransition.effect = TransitionEffect.fade;
                    PageRouteTransition.push(context, const EntryPoint(screen: GiveServiceScreen(),));
                  },
                  child: Container(
                    width: currentHeight / 3.4,
                    height: currentHeight / 8.9,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 1, // Spread radius
                            blurRadius: 2, // Blur radius
                            offset: const Offset(0, 3),
                          )
                        ],
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xFFBFEAF5)
                    ),
                    child:Center(child: const Text("Add Service",style: TextStyle(fontFamily: "ChalkBold",fontSize: 25,color: Color(0xFF707070)),textAlign: TextAlign.center,)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
