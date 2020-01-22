import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/SignUpComplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserManagement {

  storeNewUser(Name,Email,password,phonenumber,rollnumber,course,sem,user,context){
    Firestore.instance.collection('/users').document(user.uid).setData({
      'Name' : Name,
      'Email' : Email,
      'Password' : password,
      'Phone Number' : phonenumber,
      'Roll Number' : rollnumber,
      'College' : 'Siliguri Institute of Technology',
      'Course' : course,
      'Semester' : sem
    }).then((value){
        Navigator.of(context).pop();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpCompletePage()));
    }).catchError((e){
      final snackBar = SnackBar(
        content: Text('Something went wrong. Try again'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      print('sandeep${e}');
      print(e);
    });
  }

}