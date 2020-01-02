import 'dart:async';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'Home.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}
class _loginState extends State<login> {
  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        visible ? scrollToBottom() : scrollToTop();
      },
    );
    super.initState();
  }

  TextEditingController _rollnumberController = new TextEditingController();
  TextEditingController _phonenumberController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  FocusNode _focusNodePassword = FocusNode();
  bool _obsecure = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: LayoutBuilder(
          builder:(BuildContext context, BoxConstraints viewportConstraints){
            return SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(top: 120.0, right: 48.0, left: 48.0, bottom: 35.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  children: <Widget>[
                    new Image.asset('assets/images/login.png',height: 170, width: 170,),
                    SizedBox(height: 40.0,),
                    rollinput("Roll Number",_rollnumberController, false),
                    SizedBox(height: 20.0,),
                    passwordinput("Phone Number",_phonenumberController, false),
                    SizedBox(height: 40.0,),
                    buildLogInButton(),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  Widget buildLogInButton(){
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      color: Color.fromRGBO(0,21,43,1),
      onPressed: (){
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home()),);

      },
      textColor: Colors.white,
      shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),),
      child: Center(
        child: Text(
          "LogIn",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
  Widget rollinput(String hint, TextEditingController controller,
      bool obsecure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
          keyboardType: TextInputType.number,
          controller: controller,
          obscureText: obsecure,
          style: TextStyle(
            fontSize: 16,
          ),
          decoration: new InputDecoration(
            labelText: hint,
            //alignLabelWithHint: true,
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Color.fromRGBO(241, 243, 243, 1),
            filled: true,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
          ),
          onTap: () => scrollToBottom(),
          onEditingComplete: () {
            /*_focusNodePassword.requestFocus();*/
            FocusScope.of(context).requestFocus(_focusNodePassword);
          }
      ),
    );
  }
  void scrollToTop() {
    Timer(Duration(milliseconds: 50), (){
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 400),
          curve: ElasticOutCurve()
      );
    });
  }

  void scrollToBottom() {
    Timer(Duration(milliseconds: 50), (){
      _scrollController.animateTo(2000,
          duration: Duration(milliseconds: 400),
          curve: ElasticOutCurve()
      );
    });
  }
  Widget passwordinput(String hint, TextEditingController controller,
      bool obsecure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
          focusNode: _focusNodePassword,
          keyboardType: TextInputType.number,
          controller: controller,
          obscureText: obsecure,
          style: TextStyle(
            fontSize: 16,
          ),
          decoration: new InputDecoration(
            labelText: hint,
            //alignLabelWithHint: true,
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Color.fromRGBO(241, 243, 243, 1),
            filled: true,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
          ),
          onTap: () => scrollToBottom(),
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            scrollToTop();
          }
      ),
    );
  }
}



