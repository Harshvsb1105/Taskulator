
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_device_type/flutter_device_type.dart';

import 'package:intl/intl.dart';
import 'dart:collection';
import 'package:taskulator/CurrencyConverter/select_currency.dart';
import 'data/service.dart';
import 'error/error.dart';
import 'model/conversion.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

void main() => runApp(new FlutterCurrencyConverter());

class FlutterCurrencyConverter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xffffcea2),
          accentColor: Color(0xff425c5a),
          fontFamily: 'Rockwell'),
      home: new MainPage(),
      navigatorObservers: [routeObserver],
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() =>  _MainPageState();
}

class _MainPageState extends State<MainPage> with RouteAware {

  dynamic preferences = SharedPreferences;

  var _isConversionLoading = true;
  var _isRatesLoading = true;
  var _isSearchOpened = false;
  var _isKeyEntered = false;

  var service =  Services();

  var keyIndices =  List();
  var searchIndices =  List();

  var conversion =  Conversion();
  var rates =  LinkedHashMap();

  var currentValue = 1;
  var convertedValue = 0.0;

  EdgeInsets _getEdgeInsets() {
    if (Device.get().isIos && Device.get().isTablet) {
      return new EdgeInsets.fromLTRB(24.0, 36.0, 24.0, 0.0);
    }
    else if (Device.get().isTablet) {
      return new EdgeInsets.fromLTRB(24.0, 36.0, 24.0, 0.0);
    }
    else {
      return new EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0);
    }
  }

  MainAxisAlignment _getAxisAlignment() {
    if (Device.get().isIos && Device.get().isTablet) {
      return MainAxisAlignment.spaceEvenly;
    }
    else if (Device.get().isTablet) {
      return MainAxisAlignment.spaceEvenly;
    }
    else {
      return MainAxisAlignment.spaceBetween;
    }
  }

  void _initPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!(preferences.getKeys().contains("currencyParam")) && !(preferences.getKeys().contains("toParam"))) {
      await preferences.setString("currencyParam", "USD");
      await preferences.setString("toParam", "PHP");
      print("Successfully Initialized User Defaults");
    }
    else {
      print("User Defaults Already Instantiated");
    }
    setState(() {
      this.preferences = preferences;
      _isRatesLoading = true;
      _isConversionLoading = true;
      _getRates();
    });
  }

  void _swapParams() async {
    await preferences.setString("currencyParam", conversion.to);
    await preferences.setString("toParam", conversion.from);
    _getRates();
  }

  String _getImageName(String index) {
    return "assets/" + index + ".png";
  }

  String _getCurrency() {
    final currencyParam = preferences.getString("currencyParam") ?? '';
    return currencyParam;
  }

  String _getTo() {
    final toParam = preferences.getString("toParam") ?? '';
    return toParam;
  }

  String _getDate() {
    DateTime now = new DateTime.now();
    var dateFormatter = new DateFormat('MMMM dd, yyyy');

    return dateFormatter.format(now);
  }

  void _getRates() async {
    final response = await service.getRates();
    if (response is Map) {

      this.keyIndices.clear();
      for (var key in response.keys) {
        print(response[key]["flag"] + " " + response[key]["definition"] + ": " + response[key]["symbol"].toString() + response[key]["value"].toString());
        keyIndices.add(key);
      }

      setState(() {
        this.searchIndices = this.keyIndices;
        this.rates = response;
        _isRatesLoading = false;
        _getConversion();
      });
    }
    else if (response is ApiError) {
      _showDialog("Error", response.error);
    }
  }

  String _getFromSymbol() {
    return conversion.conversionRates[0]["symbol"].toString();
  }

  String _getFormattedCurrent() {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    return currentValue.toString().replaceAllMapped(reg, mathFunc);
  }

  String _getToRate() {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    var toRate = this.currentValue * this.convertedValue;

    if (toRate.toString().length > 13) {
      toRate = double.parse(toRate.toString().substring(0, 13));
    }

    var convertedRate = (conversion.conversionRates[1]["symbol"].toString() + toRate.toStringAsFixed(2));

    return convertedRate.replaceAllMapped(reg, mathFunc);
  }

  void _getConversion() async {
    final response = await service.getConversion();
    if (response is Conversion) {
      setState(() {
        this.conversion = response;

        this.currentValue = 1;
        this.convertedValue = response.rate;

        _isKeyEntered = false;
        _isConversionLoading = false;
      });
    }
    else if (response is ApiError) {
      _showDialog("Error", response.error);
    }
  }

  void _updateRate(int value) {
    if (!_isKeyEntered && currentValue == 1 && value != 0) {
      setState(() {
        this.currentValue = value;
        _isKeyEntered = true;
      });
    }
    else {
      var rateString = currentValue.toString();
      rateString = rateString += value.toString();

      if (rateString.length > 10) {
        rateString = rateString.substring(0, 10);
      }

      setState(() {
        this.currentValue = int.parse(rateString);
        _isKeyEntered = true;
      });
    }
  }

  void _removeRate() {
    if (_isKeyEntered) {
      var rateString = currentValue.toString();
      rateString = rateString.substring(0, rateString.length - 1);
      setState(() {
        if (rateString == "") {
          this.currentValue = 1;
          this._isKeyEntered = false;
        }
        else {
          this.currentValue = int.parse(rateString);
        }
      });
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(content),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
  }

  @override
  void didPopNext() {
    setState(() {
      _isRatesLoading = true;
      _isConversionLoading = true;
    });
    _getRates();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff425c5a),
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)
            )
          ),
          bottom: TabBar(
              tabs: [
                Tab(child: Text("Convert", style: new TextStyle(
                  fontSize: 13.0,
                  color: Color(0xff425c5a)
                ),
                ),
                ),
                Tab(child: Text("Rates", style: new TextStyle(
                  fontSize: 13.0,
                  color: Color(0xff425c5a)
                ),
                ),
                ),
              ]
          ),
          title: Text(_getDate(), style: new TextStyle(
            fontSize: 20.0,
            color: Color(0xff425c5a),
            fontWeight: FontWeight.bold
          ),
          ),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.refresh, color: Color(0xff425c5a)),
              onPressed: () {
                setState(() {
                  _isRatesLoading = true;
                  _isConversionLoading = true;
                });
                _getRates();
              },)
          ],
        ),
        body: TabBarView(
          children: [
            _isConversionLoading ?   Center(
              child:  CircularProgressIndicator(),
            ) :
             Column(
              children: <Widget>[
                 Padding(
                  padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                  child:  Container(
                    color: Colors.transparent,
                    child:  Container(
                      padding: EdgeInsets.all(12.0),
                      decoration:  BoxDecoration(
                        color: Color(0xffffcea2),
                        borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color:  Color(0xff425c5a),
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                      child:  Center(
                        child: Column(
                          children: <Widget>[
                             Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                 GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SelectCurrencyPage(this.keyIndices, this.rates, 0)),
                                    );
                                  },
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                       Image(image:  AssetImage(
                                          _getImageName(_getCurrency())),
                                          width: 24.0,
                                          height:24.0
                                      ),
                                       Container(
                                        width: 6.0,
                                      ),
                                       Text(_getCurrency(), style:  TextStyle(
                                        fontSize: 17.0,
                                         color:  Color(0xff425c5a)
                                      ),
                                      ),
                                       Container(
                                        width: 4.0,
                                      ),
                                       Icon(Icons.arrow_forward_ios,
                                        color: Colors.grey,
                                        size: 14.0,
                                      ),
                                    ],
                                  ),
                                ),
                                 Text(_getFromSymbol() + _getFormattedCurrent(), style: TextStyle(
                                  fontSize: 17.0,
                                   color:  Color(0xff425c5a)
                                ),
                                ),
                              ],
                            ),
                             Container(
                              height: 4.0,
                            ),
                             Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                 Container(
                                  width: 80.0,
                                  height: 0.5,
                                  color: Color.fromARGB(30, 0, 0, 0),
                                ),
                                 RawMaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      _isConversionLoading = true;
                                    });
                                    _swapParams();
                                  },
                                  child:  Icon(
                                    Icons.swap_vert,
                                    size: 20.0,
                                    color: Color(0xffffcea2),
                                  ),
                                  shape:  CircleBorder(),
                                  elevation: 4.0,
                                  fillColor:  Color(0xff425c5a),
                                  padding:  EdgeInsets.all(8.0),
                                ),
                                 Container(
                                  width: 80.0,
                                  height: 0.5,
                                  color: Color.fromARGB(30, 0, 0, 0),
                                )
                              ],
                            ),
                             Container(
                              height: 4.0,
                            ),
                              Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                 GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SelectCurrencyPage(this.keyIndices, this.rates, 1)),
                                    );
                                  },
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                       Image(image:  AssetImage(
                                          _getImageName(_getTo())),
                                          width: 24.0,
                                          height: 24.0
                                      ),
                                       Container(
                                        width: 6.0,
                                      ),
                                       Text(_getTo(), style:  TextStyle(
                                        fontSize: 17.0,
                                         color: Color(0xff425c5a)
                                      ),
                                      ),
                                       Container(
                                        width: 4.0,
                                      ),
                                       Icon(Icons.arrow_forward_ios,
                                        color: Colors.grey,
                                        size: 13.0,
                                      ),
                                    ],
                                  ),
                                ),
                                 Text(_getToRate(), style:  TextStyle(
                                  fontSize: 17.0,
                                   color: Color(0xff425c5a)
                                ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                 SizedBox(
                   height:MediaQuery.of(context).size.height * 0.01,
                 ),
                 Expanded(
                  flex: 1,
                  child:  ListView(
                    physics:  ClampingScrollPhysics(),
                    children: <Widget>[
                       Padding(
                          padding: _getEdgeInsets(),
                          child:  Column(
                            children: <Widget>[
                               Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: _getAxisAlignment(),
                                children: <Widget>[
                                   RawMaterialButton(
                                    onPressed: () {
                                      _updateRate(7);
                                    },
                                    child:  Text("7", style:  TextStyle(
                                      fontSize: 24.0,
                                      color: Color(0xff425c5a),
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 4.0,
                                    fillColor: Color(0xffffcea2),
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                   RawMaterialButton(
                                    onPressed: () {
                                      _updateRate(8);
                                    },
                                    child:  Text("8", style:  TextStyle(
                                      fontSize: 24.0,
                                      color: Color(0xff425c5a),
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 4.0,
                                    fillColor: Color(0xffffcea2),
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                   RawMaterialButton(
                                    onPressed: () {
                                      _updateRate(9);
                                    },
                                    child:  Text("9", style:  TextStyle(
                                      fontSize: 24.0,
                                      color: Color(0xff425c5a),
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 4.0,
                                    fillColor: Color(0xffffcea2),
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                ],
                              ),
                            ],
                          )
                      ),
                       Padding(
                          padding: _getEdgeInsets(),
                          child:  Column(
                            children: <Widget>[
                               Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: _getAxisAlignment(),
                                children: <Widget>[
                                   RawMaterialButton(
                                    onPressed: () {
                                      _updateRate(4);
                                    },
                                    child:  Text("4", style:  TextStyle(
                                      fontSize: 24.0,
                                      color: Color(0xff425c5a),
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 4.0,
                                    fillColor: Color(0xffffcea2),
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                   RawMaterialButton(
                                    onPressed: () {
                                      _updateRate(5);
                                    },
                                    child:  Text("5", style:  TextStyle(
                                      fontSize: 24.0,
                                      color: Color(0xff425c5a),
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 4.0,
                                    fillColor: Color(0xffffcea2),
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                   RawMaterialButton(
                                    onPressed: () {
                                      _updateRate(6);
                                    },
                                    child:  Text("6", style:  TextStyle(
                                      fontSize: 24.0,
                                      color: Color(0xff425c5a),
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 4.0,
                                    fillColor: Color(0xffffcea2),
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                ],
                              ),
                            ],
                          )
                      ),
                       Padding(
                          padding: _getEdgeInsets(),
                          child:  Column(
                            children: <Widget>[
                               Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: _getAxisAlignment(),
                                children: <Widget>[
                                   RawMaterialButton(
                                    onPressed: () {
                                      _updateRate(1);
                                    },
                                    child:  Text("1", style:  TextStyle(
                                      fontSize: 24.0,
                                      color: Color(0xff425c5a),
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 4.0,
                                    fillColor: Color(0xffffcea2),
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                   RawMaterialButton(
                                    onPressed: () {
                                      _updateRate(2);
                                    },
                                    child:  Text("2", style:  TextStyle(
                                      fontSize: 24.0,
                                      color: Color(0xff425c5a),
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 4.0,
                                    fillColor: Color(0xffffcea2),
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                   RawMaterialButton(
                                    onPressed: () {
                                      _updateRate(3);
                                    },
                                    child:  Text("3", style:  TextStyle(
                                      fontSize: 24.0,
                                      color: Color(0xff425c5a),
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 4.0,
                                    fillColor: Color(0xffffcea2),
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                ],
                              ),
                            ],
                          )
                      ),
                       Padding(
                          padding: _getEdgeInsets(),
                          child:  Column(
                            children: <Widget>[
                               Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: _getAxisAlignment(),
                                children: <Widget>[
                                   RawMaterialButton(
                                    onPressed: () {
                                    },
                                    child:  Text("", style:  TextStyle(
                                      fontSize: 24.0,
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 0.0,
                                    fillColor: Colors.transparent,
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                   RawMaterialButton(
                                    onPressed: () {
                                      _updateRate(0);
                                    },
                                    child:  Text("0", style:  TextStyle(
                                      fontSize: 24.0,
                                      color:  Color(0xff425c5a),
                                    ),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 4.0,
                                    fillColor: Color(0xffffcea2),
                                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                                  ),
                                   RawMaterialButton(
                                    onPressed: () {
                                      _removeRate();
                                    },
                                    child:  Icon(
                                      Icons.backspace,
                                      size: 24.0,
                                      color: Color(0xffa2bfbd),
                                    ),
                                    shape:  CircleBorder(),
                                    elevation: 0.0,
                                    fillColor: Color(0xff425c5a),
                                    padding:  EdgeInsets.fromLTRB(22.0, 20.0, 24.0, 20.0),
                                  ),
                                ],
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _isRatesLoading ?   Center(
              child:  CircularProgressIndicator(),
            ) :  NestedScrollView(
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
                                hintText: "Search (ex. USD, INR, EUR, GBP)",
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
                   Padding(
                    padding:  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                    child:  Container(
                      color: Colors.transparent,
                      child:  GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectCurrencyPage(this.keyIndices, this.rates, 0)),
                          );
                        },
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
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                     Image(image:  AssetImage(
                                        _getImageName(_getCurrency())),
                                        width: 18.0,
                                        height: 18.0),
                                     Container(
                                      width: 6.0,
                                    ),
                                     Text(_getCurrency()),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 14.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                   Expanded(
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
                                    child:  Column(
                                      children: <Widget>[
                                         Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                             Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                 Image(image:  AssetImage(
                                                    _getImageName(searchIndices[index])),
                                                    width: 18.0,
                                                    height: 18.0),
                                                 Container(
                                                  width: 6.0,
                                                ),
                                                 Text(searchIndices[index]),
                                              ],
                                            ),
                                             Text(rate["symbol"] + rate["value"].toStringAsFixed(2)),
                                          ],
                                        ),
                                         Divider(),
                                      ],
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
          ],
        ),
      ),
    );
  }
}