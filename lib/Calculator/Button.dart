import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final  buttonColor;
  final  textColor;
  final buttonTapped;
  final int textSize;

  Button({
    this.buttonText, this.buttonColor, this.textColor, this.buttonTapped, this.textSize
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: buttonColor,
            child: Center(child: Text(buttonText, style: TextStyle(color: textColor,fontSize: textSize.toDouble()),),),
          ),
        ),
      ),
    );
  }
}
