import 'dart:async';

import 'package:college_services/responsive.dart';
import 'package:college_services/textformfield.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: SignUpScreen (),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController _rollnumberController = new TextEditingController();
  TextEditingController _phonenumberController = new TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  FocusNode _focusNodePassword = FocusNode();
  bool _obsecure = false;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material (
      child: Container (
        height: _height,
        width: _width,
        padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new Image.asset('assets/images/user_upload.png',height: 120, width: 120,),
              SizedBox(height: 40.0,),
              form(),
              SizedBox(height: 40.0,),
              buildSignUpButton(),
              SizedBox(height: 20.0),
             // signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget form(){
    return Container(
    padding: EdgeInsets.only(
        left: _width / 6.0,
        right: _width / 6.0),
    child: Form(
      key: _key,
      child: Column(
        children: <Widget>[
          name(),
          SizedBox(height: _height / 30.0),
          phn_number(),
          SizedBox(height: _height / 40.0),
          roll_number(),
          SizedBox(height: _height / 40.0),
          college(),
          SizedBox(height: _height / 40.0),
          coursename(),
          SizedBox(height: _height / 40.0),
          sem(),
        ],
      ),
    ),
  );
  }

  Widget name(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "Full Name",
    );
  }
  Widget phn_number(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "Phone Number",
    );
  }
  Widget roll_number(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "Roll Number",
    );
  }
  Widget college(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "College",
    );
  }
  Widget coursename(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "Course",
    );
  }
  Widget sem(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "Semester",
    );
  }

  Widget buildSignUpButton(){
    return RaisedButton(
      shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),),
      color: Color.fromRGBO(255,188,114, 1),
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home()),);
      },
      textColor: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Container(
        alignment: Alignment.center,
        width: _width/1.6,
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