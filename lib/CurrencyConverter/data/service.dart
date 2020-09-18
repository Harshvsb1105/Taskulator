import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


import 'package:taskulator/CurrencyConverter/error/error.dart';
import 'package:taskulator/CurrencyConverter/model/conversion.dart';
import 'package:taskulator/CurrencyConverter/model/rates.dart';

class Services {

  String url = "https://v3.exchangerate-api.com/";
  String apiKey = "32d501ad8166eaa27ff99637";

  String get rates {
    return url + "bulk/" + apiKey + "/";
  }

  String get convertion {
    return url + "pair/" + apiKey + "/";
  }

  dynamic getRates() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final currencyParam = preferences.getString("currencyParam") ?? '';

    var url = rates + currencyParam;
    final response = await http.get(url);
    final map = json.decode(response.body);

    if (map["result"] == "success") {
      final ratesJSON = map["rates"];
      final ratesObject = Rates.fromJson(ratesJSON);

      ratesObject.initValues();

      return ratesObject.rates;
    }
    else {
      final error = ApiError.fromJson(map);
      return error;
    }
  }

  dynamic getConversion() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final currencyParam = preferences.getString("currencyParam") ?? '';
    final toParam = preferences.getString("toParam") ?? '';

    var url = convertion + currencyParam + "/" + toParam;
    final response = await http.get(url);
    final map = json.decode(response.body);

    if (map["result"] == "success") {
      final conversionObject = Conversion.fromJson(map);

      conversionObject.initValues();

      return conversionObject;
    }
    else {
      final error = ApiError.fromJson(map);
      return error;
    }
  }

}