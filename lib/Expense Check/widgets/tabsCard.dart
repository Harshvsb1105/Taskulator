import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:taskulator/Expense%20Check/provider/filterState.dart';
import 'package:taskulator/Expense%20Check/provider/settingsState.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'tabModal.dart';

class TabCard extends StatelessWidget {
  final DocumentSnapshot tab;
  TabCard({@required this.tab});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onLongPress: () {
          Provider.of<FilterState>(context,listen: false).filterByName(this.tab["name"]);
        },
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => TabModal(
              tab: this.tab,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                this.tab["name"],
                style: TextStyle(color: Color(0xff425c5a)),
              ),
              AutoSizeText(
                "${Provider.of<SettingsState>(context).selectedCurrency} ${FlutterMoneyFormatter(amount: this.tab["amount"]).output.nonSymbol}",
                style: TextStyle(color: Color(0xff425c5a), fontWeight: FontWeight.bold, fontSize: 22),
                maxLines: 1,
              ),
              Chip(
                backgroundColor: this.tab["closed"] == true
                    ? Color(0xff425c5a).withAlpha(30)
                    : this.tab["userOwesFriend"] == true
                    ? Colors.redAccent.withAlpha(30)
                    : Color(0xff425c5a).withAlpha(30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                label: Text(
                  this.tab["description"],
                  style: TextStyle(
                      color: this.tab["closed"] == true
                          ? Color(0xff425c5a)
                          : this.tab["userOwesFriend"] == true
                          ? Colors.redAccent
                          : Color(0xff425c5a)),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (this.tab["closed"] == true)
                      Text(
                        "Closed",
                        style: TextStyle(color: Color(0xff425c5a)),
                      ),
                    Text(
                      timeago.format(this.tab["closed"] == true
                          ? this.tab["timeClosed"].toDate()
                          : this.tab["time"].toDate()),
                      style: TextStyle(color: Color(0xff425c5a)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
