import 'package:college_services/login.dart';
import 'package:college_services/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        padding:
            EdgeInsets.only(top: 150.0, right: 48.0, left: 48.0, bottom: 20.0),
        child: Column(
          children: <Widget>[
            new Image.asset(
              'assets/images/example.png',
              height: 170,
              width: 170,
            ),
            SizedBox(
              height: 50.0,
            ),
            buildLogInButton(),
            SizedBox(
              height: 30.0,
            ),
            buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget buildLogInButton() {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      color: Color.fromRGBO(0, 21, 43, 1),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogIn()),
        );
      },
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Text(
          "Log In",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget buildSignUpButton() {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      color: Color.fromRGBO(255, 188, 114, 1),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => signup()),
        );
      },
      textColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
