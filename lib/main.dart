import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskulator/BMI/BMI.dart';
import 'package:taskulator/Calculator/Calculator.dart';
import 'package:taskulator/Currency%20Converter/Currency%20Converter%20main.dart';

import 'Expense Check/ExpenseCheck.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner:false,
      home: BottomNavBar()
  ));
}

class BottomNavBar extends StatefulWidget {


  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

 

  final pageOptions =[
    ExpenseCheck(),
    Calculator(),
    CurrencyConverter(),
    BMICalculator(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              backgroundColor: Color(0xff425c5a),
              buttonBackgroundColor: Color(0xffffcea2),
              height: 60,
              color: Color(0xffffcea2),
              items: [
                Icon(FontAwesomeIcons.monero,size: 30, color: Color(0xff425c5a)),
                Icon(FontAwesomeIcons.calculator, size: 30, color: Color(0xff425c5a)),
                Icon(FontAwesomeIcons.rupeeSign,size: 30, color: Color(0xff425c5a)),
                Icon(FontAwesomeIcons.weight, size: 30, color: Color(0xff425c5a)),
              ],
              animationDuration: Duration(milliseconds: 800),
              animationCurve: Curves.bounceInOut,
              onTap: (index){
                setState(() {
                  _page = index;
                });
              },

            ),
            body: pageOptions[_page]
        );
  }
}


