import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard.dart';

class CurrencyList extends StatefulWidget {
  final String selectedCurrency;

  CurrencyList({this.selectedCurrency});

  @override
  _CurrencyListState createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  List<String> currencies;

  Future<List<String>> _loadCurrencies(String currency) async {
    String uri = "https://api.exchangeratesapi.io/latest";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    currencies = curMap.keys.toList();
    if (this.mounted) {
      setState(() {});
    }
    print(currencies);
    return currencies;
  }

  @override
  void initState() {
    super.initState();
    _loadCurrencies(widget.selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    //
    // _onCurrencyOneChanged(String value) {
    //   setState(() {
    //     widget.currencyone = value;
    //   });
    // }
    //
    // _onCurrencyTwoChanged(String value) {
    //   setState(() {
    //     widget.currencytwo = value;
    //   });
    // }

    return Scaffold(
        backgroundColor: Color(0xff425c5a),
        appBar: AppBar(
          backgroundColor: Color(0xff425c5a),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xffffcea2)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
            child: Padding(
          padding: EdgeInsets.only(left: 25.0, bottom: 12.0),
          child: FutureBuilder(
            future: _loadCurrencies(widget.selectedCurrency),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.data);
              return snapshot.hasData == true
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Center(
                          child: Text(
                            '${snapshot.data[index]}',
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffffcea2)),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(CupertinoPageRoute(
                                  builder: (context) => DashboardPage(
                                        currencyVal: 0.0,
                                        isWhite: false,
                                        convertedCurrency: 0.0,
                                        currencyone: 'USD',
                                        currencytwo: snapshot.data[index],
                                      )));
                        },
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xffffcea2),
                        valueColor: AlwaysStoppedAnimation(Color(0xff425c5a)),
                      ),
                    );
            },
          ),
        )));
  }
}
