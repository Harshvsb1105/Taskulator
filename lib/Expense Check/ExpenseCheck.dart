import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskulator/Expense%20Check/provider/settingsState.dart';
import 'package:taskulator/Expense%20Check/screens/create.dart';
import 'package:taskulator/Expense%20Check/screens/home.dart';
import 'package:taskulator/Expense%20Check/screens/login.dart';
import 'package:taskulator/Expense%20Check/screens/register.dart';
import 'package:taskulator/Expense%20Check/screens/settings.dart';
import 'package:taskulator/Expense%20Check/screens/welcome.dart';
import 'package:taskulator/Expense%20Check/services/auth.dart';

void main() {
  runApp(ExpenseCheck());
}

class ExpenseCheck extends StatelessWidget {
  final Color primaryColor = Color(0xffffcea2);
  final Color accentColor = Color(0xffffcea2);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsState>(
        create: (context) => SettingsState(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Taskulator',
          theme: ThemeData(
            primaryColor: primaryColor,
            accentColor: accentColor,
            scaffoldBackgroundColor: Color(0xff425c5a),
            appBarTheme: AppBarTheme(color: Colors.white),
            fontFamily: 'Rubik',
            textTheme: TextTheme(
              headline4:
              TextStyle(color: Color(0xffffcea2), fontWeight: FontWeight.bold),
              headline3: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              button: TextStyle(color: Colors.white),
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: primaryColor,
              textTheme: ButtonTextTheme.normal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.all(8),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(style: BorderStyle.none),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          routes: {
            Welcome.id: (context) => Welcome(),
            Register.id: (context) => Register(),
            Login.id: (context) => Login(),
            NewTab.id: (context) => NewTab(),
            Settings.id: (context) => Settings(),
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (BuildContext context) =>
                  Scaffold(body: Center(child: Text('Not Found'))),
            );
          },
          home: FutureBuilder<FirebaseUser>(
            future: Auth.getCurrentUser(),
            builder: (context, AsyncSnapshot<FirebaseUser> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.done) {
                if (userSnapshot.error != null) {
                  print("error");
                  return Text(userSnapshot.error.toString());
                }
                return userSnapshot.hasData
                    ? Home(userSnapshot.data.uid)
                    : Welcome();
              } else {
                return Text(
                  "Tabs",
                  style: Theme.of(context).textTheme.headline4,
                );
              }
            },
          ),
        ),
      );

  }
}

