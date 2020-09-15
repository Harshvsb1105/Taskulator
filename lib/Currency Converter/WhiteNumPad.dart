import 'dart:convert';

import 'package:flutter/material.dart';
import 'currencyService.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';


class InputWhitePage extends StatefulWidget {
  final origCurrency;
  final convCurrency;

  InputWhitePage({this.origCurrency, this.convCurrency});

  @override
  _InputWhitePageState createState() => _InputWhitePageState();
}

class _InputWhitePageState extends State<InputWhitePage> {
  var currInput = 0;
  String result;


  Future<String> convertCurrency(String fromCurrency, String toCurrency, int currInput, context) async {
    String uri = "https://api.exchangeratesapi.io/latest?base=$fromCurrency&symbols=$toCurrency";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    setState(() {
      result = (double.parse(currInput.toString()) * (responseBody["rates"][toCurrency])).toStringAsFixed(3);
    });
    print(result);
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => DashboardPage(
              currencyVal: currInput,
              convertedCurrency: result,
              currencyone: fromCurrency,
              currencytwo: toCurrency,
              isWhite: false,
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff425c5a),
      body: Column(
        children: <Widget>[
          SizedBox(height: 80.0),
          InkWell(
            onTap: () {
              setState(() {
                currInput = 0;
              });
            },
            child: Text(
              'Tap to delete',
              style: TextStyle(
                  color: Color(0xffffcea2),
                  fontSize: 17.0,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(
              currInput.toString(),
              style: TextStyle(
                  color: Color(0xffffcea2),
                  fontSize: 100.0,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 25.0),
          numberRow(1, 2, 3),
          SizedBox(height: 25.0),
          numberRow(4, 5, 6),
          SizedBox(height: 25.0),
          numberRow(7, 8, 9),
          SizedBox(height: 25.0),
          finalRow(),
          SizedBox(height: 25,),
          IconButton(
            icon: Icon(Icons.arrow_downward, color: Color(0xffffcea2)),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget numberRow(number1, number2, number3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          onTap: () {
            calculateNumber(number1);
          },
          child: Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: Color(0xffffcea2)),
            child: Center(
              child: Text(
                number1.toString(),
                style: TextStyle(
                    color: Color(0xff425c5a),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            calculateNumber(number2);
          },
          child: Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: Color(0xffffcea2)),
            child: Center(
              child: Text(
                number2.toString(),
                style: TextStyle(
                    color: Color(0xff425c5a),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            calculateNumber(number3);
          },
          child: Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: Color(0xffffcea2)),
            child: Center(
              child: Text(
                number3.toString(),
                style: TextStyle(
                    color: Color(0xff425c5a),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget finalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          onTap: () {
            // calculateNumber(number1);
          },
          child: Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: Color(0xffffcea2)),
            child: Center(
              child: Text(
                '.',
                style: TextStyle(
                    color: Color(0xff425c5a),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            calculateNumber(0);
          },
          child: Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: Color(0xffffcea2)),
            child: Center(
              child: Text(
                0.toString(),
                style: TextStyle(
                    color: Color(0xff425c5a),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
              convertCurrency(widget.origCurrency, widget.convCurrency, currInput, context);
          },
          child: Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0), color: Color(0xff425c5a)),
            child: Center(
                child: Icon(
                  Icons.check,
                  color: Color(0xffffcea2),
                  size: 45.0,
                )),
          ),
        )
      ],
    );
  }

  calculateNumber(number) {
    if (currInput == 0) {
      setState(() {
        currInput = number;
      });
    } else {
      setState(() {
        currInput = (currInput * 10) + number;
      });
    }
  }
}
