import 'package:college_services/main.dart';
import 'package:college_services/responsive.dart';
import 'package:college_services/signup.dart';
import 'package:flutter/material.dart';
import 'Home.dart';

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
        padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new Image.asset('assets/images/example.png',height: 170, width: 170,),
              SizedBox(height: 40.0,),
              rollinput("Roll Number",_rollnumberController, _obsecure),
              SizedBox(height: 20.0,),
              passwordinput("Phone Number",_phonenumberController, _obsecure),
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

  Widget buildLogInButton(){
    return RaisedButton(
      shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),),
      color: Color.fromRGBO(0,21,43,1),
      onPressed: (){
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home()),);
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
  Widget rollinput(String hint, TextEditingController controller,
      bool obsecure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      width: _width/1.3,
      child: TextField(
          keyboardType: TextInputType.number,
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
          }
      ),
    );
  }

  Widget passwordinput(String hint, TextEditingController controller,
      bool obsecure) {
    return Container(
      width: _width/1.3,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
          focusNode: _focusNodePassword,
          keyboardType: TextInputType.number,
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
          }
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
}



