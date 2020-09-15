import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskulator/Expense%20Check/controllers/tabsController.dart';
import 'package:taskulator/Expense%20Check/screens/settings.dart';
import 'package:taskulator/Expense%20Check/services/auth.dart';
import 'package:taskulator/Expense%20Check/widgets/tabsContainer.dart';

import '../../main.dart';
import 'create.dart';

class Home extends StatelessWidget {
  static const String id = "home_screen";
  final String uid;
  Home(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff425c5a),
      body: Stack(
        children: <Widget>[
          Container(
            height: 225,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.6],
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(
                    MediaQuery.of(context).size.width * 0.50, 18),
                bottomRight: Radius.elliptical(
                    MediaQuery.of(context).size.width * 0.50, 18),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.exit_to_app, color: Color(0xff425c5a),),
              onPressed: () {
                _showSignOutDialog(context);
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 5,
            child: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.settings,color: Color(0xff425c5a),),
              onPressed: () {
                Navigator.of(context).pushNamed(Settings.id);
              },
            ),
          ),
          SafeArea(
            child: MultiProvider(
              providers: [
                StreamProvider<QuerySnapshot>(
                  create: (context) => TabsController.getUsersTabs(this.uid),
                ),
              ],
              child: TabsContainer(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool flag = await Auth.isEmailVerified();
          if (flag)
            Navigator.pushNamed(context, NewTab.id);
          else
            _showEmailConfirmDialog(context);
        },
        child: Icon(Icons.add, color: Color(0xff425c5a),),
      ),
    );
  }
}

void _showSignOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff425c5a),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text("Confirm sign out?",style: TextStyle(color: Color(0xffffcea2)),),
          content: Text("Your Tabs will still be here next time you sign in", style: TextStyle(color:Color(0xffffcea2) ),),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              textColor: Color(0xffffcea2),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Sign Out"),
              textColor: Color(0xffa2bfbd),
              onPressed: () {
                Auth.logOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
              },
            ),
          ],
        );
    },
  );
}

void _showEmailConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff425c5a),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text("Sorry, you need to verify your email first",style: TextStyle(color: Color(0xffffcea2))),
          content: Text("Please check your email",style: TextStyle(color: Color(0xffffcea2))),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              textColor: Color(0xffffcea2),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Resend Email"),
              textColor: Color(0xffa2bfbd),
              onPressed: () {
                Auth.sendEmailVerification();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
    },
  );
}
