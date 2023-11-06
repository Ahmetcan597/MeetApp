import 'package:appoflutter/Widgets/HumansWidget.dart';
import 'package:appoflutter/Widgets/ProfileButton.dart';
import 'package:appoflutter/Widgets/TopSide.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
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
                const Text("Your Chats",style: TextStyle(fontFamily: "ChalkBold",fontSize: 25,color: Color(0xFF707070)),textAlign: TextAlign.center,),
              ],
            ),
            Container(height: currentHeight / 89,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50)
              ),
              height: currentHeight / 1.48,
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
          ],
        ),
      ),
    );
  }
}
