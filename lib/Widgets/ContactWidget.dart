import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  const ContactWidget({
    super.key, required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: 350,
        height: 40,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 1, // Spread radius
                blurRadius: 2, // Blur radius
                offset: const Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text,style: TextStyle(fontFamily: "ChalkBold",fontSize: 16,color: Color(0xFF707070)),textAlign: TextAlign.start,),
          ),
        ),
      ),
    );
  }
}