import 'package:flutter/material.dart';

class TextFieldContainer extends StatefulWidget {
  const TextFieldContainer({
    super.key,
    required this.currentHeight, required this.hintText, required this.currentWidth, required this.hintSize, required this.textSize, required this.onTextChanged,
  });

  final double currentWidth;
  final double currentHeight;
  final String hintText;
  final double hintSize;
  final double textSize;
  final ValueChanged<String> onTextChanged;

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {

  String myText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.currentWidth,
      height: widget.currentHeight,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 2, // Blur radius
              offset: Offset(0, 3),
            )
          ],
          borderRadius: BorderRadius.circular(50),
          color: Colors.white
      ),
      child: Center(
        child: TextField(
          onChanged: (text) {
            setState(() {
              myText = text;
            });
            widget.onTextChanged(myText);
          },
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: widget.hintSize,
              fontFamily: 'Mr. Rockwell',
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextStyle(
            fontSize: widget.textSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}