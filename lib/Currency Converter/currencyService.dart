import 'package:flutter/material.dart';
import 'package:taskulator/Currency%20Converter/dashboard.dart';

class CurrencyService {
  getCurrencyString(String currency){
    if(currency == 'USD') return 'United States Dollar';
    if(currency == 'RUB') return 'Russian Ruble';
    if (currency == 'JPY') return 'Japanese Yen';
    if (currency == 'INR') return 'Indian Rupee';
    if (currency == 'GBP') return 'Pound Sterling';
  }
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