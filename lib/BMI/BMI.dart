import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'input_page.dart';

void main() {
  runApp(BMICalculator());
}

class BMICalculator extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xff425c5a),
        scaffoldBackgroundColor: Color(0xff425c5a),
      ),
      home: InputPage(),
    );
  }
}