import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/SignUpComplete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
 /* final String uid;
  UserManagement({ this.uid });*/
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
        content: Text(e.message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  getData() async{
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    print(userId);
    return Firestore.instance.collection('users').document(userId).get();
  }

  getCurrentUser()async{
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    return userId;
  }



}