import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/Home.dart';
import 'package:college_services/SignUpComplete.dart';
import 'package:college_services/pages/Homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  String uid;
  storeNewUser(Name,Email,password,phonenumber,ImageUrl,rollnumber,course,sem,user,context){
    Firestore.instance.collection('/users').document(user.uid).setData({
      'Name' : Name,
      'Email' : Email,
      'Image Url' : ImageUrl,
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

  getProfileData(userID) async{
    print(' this is in usermanagement $userID');
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    print('Current user $userId');
    if(userID!=null){
      return Firestore.instance.collection('users').document(userID).get();
    }
    else{
      return Firestore.instance.collection('users').document(userId).get();
    }
   }

  getCurrentUser()async{
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    return userId;
  }

  addPost(Name,Des,UserImageUrl,ImageUrl,PhoneNumber,context) async {
    var date = new DateTime.now();
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    Firestore.instance.collection('/Posts').document('$Name : $date',).setData({
      'Creation Time':date,
      'Name': Name,
      'Userid':userId,
      'User Pic': UserImageUrl,
      'Image Urls' : ImageUrl,
      'Description': Des,
      'PhoneNumber': PhoneNumber
    }).then((value){
      Navigator.of(context).pop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }).catchError((e){
      final snackBar = SnackBar(
        content: Text(e.message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  getPosts() async{
    QuerySnapshot Qn = await Firestore.instance.collection("Posts").orderBy("Creation Time", descending: true).getDocuments();
    return Qn.documents;
  }


}