import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:collection';

class SelectCurrencyPage extends StatefulWidget {

  int navIndex;
  var keyIndices =  List();
  var rates =  LinkedHashMap();

  SelectCurrencyPage(this.keyIndices, this.rates, this.navIndex);

  @override
  _SelectCurrencyState createState() => new _SelectCurrencyState(keyIndices, rates, navIndex);
}

class _SelectCurrencyState extends State<SelectCurrencyPage> {

  dynamic preferences = SharedPreferences;

  var _isSearchOpened = false;

  int navIndex;
  var keyIndices =  List();
  var searchIndices =  List();

  var rates = LinkedHashMap();

  _SelectCurrencyState(this.keyIndices, this.rates, this.navIndex) {
    this.searchIndices = keyIndices;
  }

  void _setPreferences(String index) async {
    if (navIndex == 0) {
      await preferences.setString("currencyParam", index);
      print("Successfully Set " + index + " as currencyParam");
    }
    else if (navIndex == 1) {
      await preferences.setString("toParam", index);
      print("Successfully Set " + index + " as toParam");
    }

    setState(() {
      this.preferences = preferences;
    });
  }

  void _initPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      this.preferences = preferences;
    });
  }

  String _getImageName(String index) {
    return "assets/" + index + ".png";
  }

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:  Text("Select Currency", style: new TextStyle(
          fontSize: 15.0,
        ),
        ),
      ),
      body:  NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
          ];
        },
        body:  Column(
          children: <Widget>[
             Padding(
              padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
              child:  Container(
                color: Colors.transparent,
                child:  Container(
                  padding:  EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius:  BorderRadius.all(const Radius.circular(10.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child:  Center(
                    child:  Container(
                      child:  TextField(
                        decoration:  InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: "Search (ex. USD, INR, EUR,)",
                          border: InputBorder.none,
                        ),
                        style:  TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontFamily: "Futura",
                        ),
                        onChanged: (text) {
                          setState(() {
                            _isSearchOpened = true;
                          });
                        },
                        onSubmitted: (text) {
                          var searchIndices = List();
                          if (text.isEmpty) {
                            searchIndices = this.keyIndices;
                          }
                          else {
                            searchIndices = keyIndices.where((item) => item.toString().contains(text.trim().toUpperCase())).toList();
                          }
                          setState(() {
                            this.searchIndices = searchIndices;
                            this.rates = this.rates;
                            _isSearchOpened = false;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            new Expanded(
              flex: 1,
              child:  Padding(
                padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                child:  Container(
                  color: Colors.transparent,
                  child:  Container(
                    padding:  EdgeInsets.all(12.0),
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      borderRadius:  BorderRadius.all(const Radius.circular(10.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child:  Center(
                      child: _isSearchOpened ?  Center(
                        child:  CircularProgressIndicator(),
                      ) :  ListView.builder(
                          itemCount: this.rates != null ? this.searchIndices.length : 0,
                          itemBuilder: (context, index) {
                            final rate = rates[this.searchIndices[index]];
                            return  Container(
                              height: 42.0,
                              child:  GestureDetector(
                                onTapUp: (tapDetails) {
                                  _setPreferences(searchIndices[index]);
                                  Navigator.pop(context);
                                },
                                child: Column(
                                  children: <Widget>[
                                     Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                         Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                             Image(image: new AssetImage(
                                                _getImageName(searchIndices[index])),
                                                width: 18.0,
                                                height: 18.0),
                                             Container(
                                              width: 6.0,
                                            ),
                                            new Text(searchIndices[index]),
                                          ],
                                        ),
                                        new Text(rate["definition"], style: new TextStyle(
                                          fontSize: 12.0,
                                        ),
                                        ),
                                      ],
                                    ),
                                    new Divider(),
                                  ],
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}