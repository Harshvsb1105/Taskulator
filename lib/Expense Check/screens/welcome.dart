
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:taskulator/Expense%20Check/services/auth.dart';
import './register.dart';
import 'home.dart';
import 'login.dart';

class Welcome extends StatefulWidget {
  static const String id = 'welcome';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // ModalRoute.of(context).settings.name == null;       //bug
    // ModalRoute.of(context).settings.arguments != null;  //ok
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: loading
          ? Center(
        child: SpinKitDoubleBounce(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
      )
          : Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "Tally",
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    "The expense sharing app.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 50),
                  Image(
                    image: AssetImage(
                      'assets/graphics/study-from-books.png',
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SignInButton(
                            Buttons.Google,
                            onPressed: () async {
                              setState(() => loading = true);
                              final user = await Auth.googleSignIn();
                              setState(() => loading = false);
                              if (user != null)
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home(user)),
                                    ModalRoute.withName("/")
                                );
                            },
                          ),
                          Row(children: <Widget>[
                            Expanded(child: Divider(color: Color(0xffffcea2),)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("OR", style: TextStyle(color: Color(0xffffcea2)),),
                            ),
                            Expanded(child: Divider(color: Color(0xffffcea2),)),
                          ]),
                          RaisedButton(
                            child: Text("Create Account", style: TextStyle(color: Color(0xff425c5a)),),
                            onPressed: () {
                              Navigator.pushNamed(context, Register.id);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, Login.id);
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
