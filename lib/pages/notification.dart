import 'package:flutter/material.dart';


class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Container(
        child: Center(
          child: Text(
            'Nothing to show',
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}