import 'package:flutter/material.dart';
import 'createForm.dart';

class NewTab extends StatelessWidget {
  static const String id = "create_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("New Tab",style: TextStyle(color: Color(0xffffcea2)),),
      backgroundColor: Color(0xff425c5a),
        iconTheme: IconThemeData(color : Color(0xffffcea2)),
      ),
      body: Center(
          child: CreateForm()
      ),
    );
  }
}
