import 'package:flutter/material.dart';
import 'login.dart';

class SignUpCompletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Login"),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LogIn()));
            },
          ),
        ],
      ),
    );
  }
}
