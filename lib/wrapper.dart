import 'package:college_services/authProvider.dart';
import 'package:college_services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'Home.dart';
import 'Root.dart';

class Wrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WrapperState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _WrapperState extends State<Wrapper> {
  ProgressDialog pr;

  AuthStatus authStatus = AuthStatus.notDetermined;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUser().then((String userId){
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }
  double _height;
  double _width;

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
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

    switch(authStatus){
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return RootPage();
      case AuthStatus.signedIn:
        return HomePage();
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold (
      body: Container (
        height: _height,
        width: _width,
        padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new Image.asset('assets/images/example.png',height: 170, width: 170,),
            ],
          ),
        ),
      ),
    );
  }

}