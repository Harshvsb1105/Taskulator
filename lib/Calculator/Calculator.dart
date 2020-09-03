import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import 'Button.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userQuestion = '';
  var userAnswer = '';


  final List<String> buttons = [
    'AC',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    'x',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userQuestion,
                        style: TextStyle(fontSize: 20, color: Color(0xff425c5a)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        userAnswer,
                        style: TextStyle(fontSize: 40,color: Color(0xff425c5a)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(0xff425c5a),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                ),
                child: GridView.builder(
                    itemCount: buttons.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return
                          //All Clear
                          Button(
                            buttonTapped: () {
                              setState(() {
                                userQuestion = '';
                                userAnswer = '';
                              });
                            },
                            buttonText: buttons[index],
                            buttonColor: Color(0xff425c5a),
                            textColor: Color(0xffa2bfbd),
                            textSize: 20,
                          );
                      } else if (index == 1) {
                        return
                          // Delete
                          Button(
                            buttonTapped: () {
                              setState(() {
                                if (userQuestion.length == 0) {
                                } else {
                                  userQuestion = userQuestion.substring(
                                      0, userQuestion.length - 1);
                                }
                              });
                            },
                            buttonText: buttons[index],
                            buttonColor: Color(0xff425c5a),
                            textColor: Color(0xffa2bfbd),
                            textSize: 20,
                          );
                      } else if (index == buttons.length - 1) {
                        return
                          // Equal button
                          Button(
                            buttonTapped: () {
                              setState(() {
                                equalPressed();
                              });
                            },
                            buttonText: buttons[index],
                            buttonColor: Color(0xff425c5a),
                            textColor: Color(0xffffcea2),
                            textSize: 35,
                          );
                      } else {
                        return Button(
                          buttonTapped: () {
                            setState(() {
                              userQuestion += buttons[index];
                            });
                          },
                          buttonText: buttons[index],
                          // buttonColor: Color(0xffffcea2),
                          buttonColor: isOperator(buttons[index])
                              ? Color(0xff425c5a)
                              : Color(0xffffcea2),
                          // textColor: Color(0xff425c5a),
                          textColor: isOperator(buttons[index])
                              ? Color(0xffffcea2)
                              : Color(0xff425c5a),
                          textSize: isOperator(buttons[index]) ? 30 : 20,
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '%' || x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*');
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = eval.toString();
    userAnswer = userAnswer.replaceAll('=', 'ANS');
  }
}
