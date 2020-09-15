import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskulator/Expense%20Check/services/auth.dart';

class ForgotPass extends StatefulWidget {
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool emailSent = false;

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter a valid Email';
    else
      return null;
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      try {
        await Auth.resetPassword(_emailController.text);
        setState(() {
          emailSent = true;
        });
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff425c5a),
        iconTheme: IconThemeData(color: Color(0xffffcea2),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: !emailSent
              ? Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Forgot Your Password?",
                      style: TextStyle(color: Color(0xffffcea2),fontSize: 25,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    "Enter your email and we'll send you instructions.",
                    style: TextStyle(color: Color(0xffffcea2)),
                  ),
                  SizedBox(height: 36),
                  TextFormField(
                    style: TextStyle(color: Color(0xffffcea2)),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    controller: _emailController,
                    validator: (value) => validateEmail(value),
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Color(0xffffcea2)),
                      prefixIcon: Icon(Icons.email,color: Color(0xffffcea2),),
                    ),
                  ),
                  SizedBox(height: 12),
                  RaisedButton(
                    child: Text("Submit",style: TextStyle(color: Color(0xff425c5a)),),
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
          )
              : Center(
                child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Text("Reset email sent to",
                    style: TextStyle(color: Color(0xffffcea2),fontWeight: FontWeight.bold,fontSize: 30)),
                SizedBox(height: 10,),
                // SizedBox(height: 12),
                Text(_emailController.text,
                    style: TextStyle(color: Color(0xffffcea2),fontSize: 20,fontWeight: FontWeight.bold)),
                SizedBox(height: 36),
                Text("Please check your email",
                    style: TextStyle(color: Color(0xffa2bfbd))),
            ],
          ),
              ),
        ),
      ),
    );
  }
}
