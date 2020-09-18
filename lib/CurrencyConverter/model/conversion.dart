import 'package:taskulator/CurrencyConverter/model/rates.dart';

class Conversion {

  var ratesObject = Rates();

  String from = "";
  String to = "";
  double rate;

  var conversionRates = List();

  Conversion();

  void initValues() {
    ratesObject.initValues();

    conversionRates.add(ratesObject.rates[from]);
    conversionRates.add(ratesObject.rates[to]);
  }

  Conversion.fromJson(Map<String, dynamic> json):
        from = json["from"],
        to = json["to"],
        rate = (json['rate'] != null) ? json['rate'] + 0.0 : 0.0;
}