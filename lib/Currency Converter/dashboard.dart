import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskulator/Currency%20Converter/CurrencyList.dart';
import 'package:taskulator/Currency%20Converter/currencyService.dart';
import 'package:taskulator/Currency%20Converter/GreenNumPad.dart';
import 'package:http/http.dart' as http;
import 'WhiteNumPad.dart';

class DashboardPage extends StatefulWidget {
  final currencyVal;
  final convertedCurrency;
  String currencyone;
  String currencytwo;
  final isWhite;


    DashboardPage({this.currencyVal, this.convertedCurrency, this.currencyone, this.currencytwo, this.isWhite});
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Color(0xff425c5a),
            ),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.white,
            ),
            Container(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 130.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => CurrencyList()
                        ));
                      },
                      child: Text('${CurrencyList(selectedCurrency: widget.currencyone,) ?? 'INR'}',
                          style: TextStyle(
                            color: Color(0xff425c5a),
                            fontSize: 22.0,
                            fontFamily: 'Quicksand',
                          )
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                InputWhitePage(
                                  origCurrency: widget.currencyone,
                                  convCurrency: widget.currencytwo,
                                )));
                      },
                      child: AutoSizeText((widget.currencyVal.toString()),
                          style: TextStyle(
                            color: Color(0xff425c5a),
                            fontSize: 120.0,
                            fontFamily: 'Quicksand',
                          ),
                        maxLines: 1,
                      ),
                    ),
                    Text(widget.currencyone,
                      style: TextStyle(
                          color: Color(0xff425c5a),
                          fontSize: 17.0,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold
                      ),),
                    SizedBox(height: 25.0),
                    Container(
                      height: 125.0,
                      width: 125.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(62.5),
                        color: Colors.white,
                        border: Border.all(
                            color: Color(0xff425c5a),
                            style: BorderStyle.solid,
                            width: 5.0
                        ),
                      ),
                      child: Center(
                          child: widget.isWhite ?
                          Icon(Icons.arrow_upward, size: 60, color: Color(
                              0xff425c5a)) :
                          Icon(Icons.arrow_downward, size: 60, color: Color(
                              0xff425c5a))
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      widget.currencytwo,
                      style: TextStyle(
                          color: Color(0xffffcea2),
                          fontSize: 17.0,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                InputGreenPage(
                                  origCurrency: widget.currencyone,
                                  convCurrency: widget.currencytwo,
                                )
                        ));
                      },
                      child: AutoSizeText(
                        widget.convertedCurrency.toString(),
                        style: TextStyle(
                            color: Color(0xffffcea2),
                            fontSize: 120.0,
                            fontFamily: 'Quicksand'),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => CurrencyList()
                        ));
                      },
                      child: Text(
                          '${CurrencyList(selectedCurrency: widget.currencytwo,)}',
                        style: TextStyle(
                            color: Color(0xffffcea2),
                            fontSize: 22.0,
                            fontFamily: 'Quicksand'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }
