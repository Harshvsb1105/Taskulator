import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskulator/Expense%20Check/provider/settingsState.dart';

class Settings extends StatelessWidget {
  static const String id = "/settings";
  final currencies = SettingsState.currencies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Settings",style: TextStyle(color: Color(0xffffcea2),fontSize: 30,fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xff425c5a),
        iconTheme: IconThemeData(color: Color(0xffffcea2)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Currency",
                style: TextStyle(color: Color(0xffffcea2),fontWeight: FontWeight.bold,fontSize: 20),
              ),
              Wrap(
                spacing: 8,
                children: List<Widget>.generate(
                  currencies.length,
                      (int index) {
                    return ChoiceChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      label: Text(currencies[index]),
                      selected: currencies[index] ==
                          Provider.of<SettingsState>(context).selectedCurrency,
                      onSelected: (bool selected) {
                        if (selected)
                          Provider.of<SettingsState>(context, listen: false)
                              .selectCurrency(currencies[index]);
                      },
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 20,),
              Center(
                child: RaisedButton(
                  child: Text('OK', style: TextStyle(color: Color(0xff425c5a)),),
                  color: Color(0xffffcea2),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
