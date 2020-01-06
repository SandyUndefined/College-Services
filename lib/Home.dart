import 'package:college_services/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  /*Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text("Home"),
      ),
    );
  }*/
}
class _HomePageState extends State<Home>{
  String uid = '';
  getUid(){}
  @override
  void initState() {
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Dashboard'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('You are now logged in as ${uid}'),
                SizedBox(
                  height: 15.0,
                ),
                new OutlineButton(
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 3.0),
                  child: Text('Logout'),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((action) {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LogIn()),);
                    }).catchError((e) {
                      print(e);
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }

}