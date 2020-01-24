import 'dart:developer';

import 'package:college_services/services/responsive.dart';
import 'package:college_services/signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LogInScreen(),
    );
  }
}

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {

  String _email;
  String _password;


  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController _Email = new TextEditingController();
  TextEditingController _Password = new TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();

  FocusNode _focusNodePassword = FocusNode();


  ProgressDialog pr;


  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(
      message: 'Loading...',
      borderRadius: 3.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 8.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
    );
    return Scaffold (
      body: Container (
        height: _height,
        width: _width,
        padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new Image.asset('assets/images/example.png',height: 170, width: 170,),
              SizedBox(height: 40.0,),
              form(),
              SizedBox(height: 40.0,),
              buildLogInButton(),
              SizedBox(height: 10.0,),
              signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget form(){
    return Container(
      /*padding: EdgeInsets.only(
          left: _width / 6.0,
          right: _width / 6.0),*/
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            email("Email",_Email,false),
            SizedBox(height: 20.0,),
            password("Password",_Password,true),
            /*SizedBox(height: 40.0),
          buildSignUpButton(),
          SizedBox(height: 20.0),*/
          ],
        ),
      ),
    );
  }

  Widget email(String hint,TextEditingController controller, bool obsecure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      width: _width/1.3,
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          obscureText: obsecure,
          style: TextStyle(
            fontSize: 14,
          ),
          decoration: new InputDecoration(
            labelText: hint,
            alignLabelWithHint: true,
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Color.fromRGBO(241, 243, 243, 1),
            filled: true,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(22.0),
            ),
          ),
          onEditingComplete: () {
            /*_focusNodePassword.requestFocus();*/
            FocusScope.of(context).requestFocus(_focusNodePassword);
          },
          validator: (value) => !EmailValidator.validate(value, true)
              ? 'Not a valid email.'
              : null,
          onChanged: (value){
          setState(() {
          _email = value;
             });
          }),
    );
  }

  Widget password(String hint,TextEditingController controller, bool obsecure) {
    return Container(
      width: _width/1.3,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
          validator: validatepassword,
          focusNode: _focusNodePassword,
          keyboardType: TextInputType.text,
          controller: controller,
          obscureText: obsecure,
          style: TextStyle(
            fontSize: 14,
          ),
          decoration: new InputDecoration(
            labelText: hint,
            alignLabelWithHint: true,
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            fillColor: Color.fromRGBO(241, 243, 243, 1),
            filled: true,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(22.0),
            ),
          ),
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          onChanged: (value){
         setState(() {
        _password = value;
        });
        },
      ),
    );
  }

  Widget buildLogInButton(){
    return RaisedButton(
      shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),),
      color: Color.fromRGBO(0,21,43,1),
      onPressed: (){
        if(_key.currentState.validate()){
        pr.show();
        Future.delayed (Duration(seconds: 2), ).then((onValue){
          if(pr.isShowing())
            {
              login();
              Future.delayed(Duration(seconds: 3),).then((onValue){
                pr.hide();
              });
            }
        }
        );
        _key.currentState.save();
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Container(
        alignment: Alignment.center,
        width: _width/1.7,
        child: Text(
          "LogIn",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => signup()),);
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Color.fromRGBO(255,188,114, 1), fontSize: _large? 19: (_medium? 17: 15)),
            ),
          )
        ],
      ),
    );
  }

  String validatepassword(String value) {
    if(value.length < 6 ){
      return 'Password must be longer than 6 digit';
    }
    else
      return null;
  }

  void login() async {
     if(_key.currentState.validate()){
       FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)
       .then((user){
         Navigator.of(context).pop();
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

       }).catchError((error){
         final snackBar = SnackBar(
           content: Text(error.message),
           action: SnackBarAction(
             label: 'Retry',
             onPressed: () {
               _Email.clear();
               _Password.clear();
               },
           ),
         );
         Scaffold.of(context).showSnackBar(snackBar);
         print('sandeep${error}');
       });
     }
  }
}



