import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SignUpCompletePage extends StatelessWidget {
  double _width, _height;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(225, 225, 225, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/success.png",
              fit: BoxFit.cover,
              width: 140,
              height: 140,
            ),
            SizedBox(height: 35,),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Color.fromRGBO(0, 21, 43, 1),
              child: Container(
                  alignment: Alignment.center,
                  width: _width / 3,
                  height: _height / 12,
                  child: Text(
                    "LogIn",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  )),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LogIn()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
