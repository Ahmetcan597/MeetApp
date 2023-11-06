import 'package:appoflutter/Widgets/ProfileButton.dart';
import 'package:flutter/material.dart';


class TopSide extends StatelessWidget {
  const TopSide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 90,),
        const Text("AppVery",style: TextStyle(fontFamily: "ChalkBold",fontSize: 50,color: Color(0xFF707070)),textAlign: TextAlign.center,),
        Container(width: 15,),
        ProfileButton(),
      ],
    );
  }
}