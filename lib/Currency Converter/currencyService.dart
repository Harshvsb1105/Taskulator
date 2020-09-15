import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taskulator/Currency%20Converter/dashboard.dart';
import 'package:http/http.dart' as http;


class CurrencyService {
  final fromTextController = TextEditingController();
  String fromCurrency = "USD";
  String toCurrency = "GBP";
  String result;
  List<String> currencies;


  Future<List<String>> getCurrencyString() async {
    String uri = 'https://api.exchangeratesapi.io/latest';
    var response = await http
        .get(Uri.encodeFull(uri), headers: {'Accept': 'application/json'});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    return currencies = curMap.keys.toList();
  }

  // Future<String> convertCurrency() async {
  // String uri = "https://api.exchangeratesapi.io/latest?base=$fromCurrency&symbols=$toCurrency";
  // var response = await http
  //     .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
  // var responseBody = json.decode(response.body);
  // return result = (double.parse(fromTextController.text) * (responseBody["rates"][toCurrency])).toString();
  // }

  // getCurrencyString(String currency){
  //   if(currency == 'USD') return 'United States Dollar';
  //   if(currency == 'RUB') return 'Russian Ruble';
  //   if (currency == 'JPY') return 'Japanese Yen';
  //   if (currency == 'INR') return 'Indian Rupee';
  //   if (currency == 'GBP') return 'Pound Sterling';
  // }
  convertCurrency(String fromCurrency, String toCurrency, int amount, context){
    if(fromCurrency == 'USD'){
      switch (toCurrency){
        case 'RUB' :
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DashboardPage(
              currencyVal: amount,
              convertedCurrency: (amount * 65).roundToDouble(),
              currencyone: fromCurrency,
              currencytwo: toCurrency,
              isWhite: false,
            )
          ));
      }
    }
    if(fromCurrency == 'RUB'){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => DashboardPage(
                currencyVal: (amount / 65).toStringAsFixed(2),
                convertedCurrency: amount,
                currencyone: toCurrency,
                currencytwo: fromCurrency,
                isWhite: true,
              )
          ));
      }
    }
  }
