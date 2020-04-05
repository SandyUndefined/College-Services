import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/Home.dart';
import 'package:college_services/SignUpComplete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class UserManagement {
  String uid;
  bool showPassword = true;

  storeNewUser(Name, Email, password, phonenumber, ImageUrl, rollnumber, course,
      sem, user, context) {
    Firestore.instance.collection('/users').document(user.uid).setData({
      'Name': Name,
      'Email': Email,
      'User ID': user.uid,
      'Image Url': ImageUrl,
      'Password': password,
      'Phone Number': phonenumber,
      'Roll Number': rollnumber,
      'College': 'Siliguri Institute of Technology',
      'Course': course,
      'Semester': sem,
      'Show Password': showPassword,
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => SignUpCompletePage()));
    }).catchError((e) {
      final snackBar = SnackBar(
        content: Text(e.message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  getData() async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    print('This in usermanagement $userId');
    return Firestore.instance.collection('users').document(userId).get();
  }

  getProfileData(userID) async {
    print(' this is in usermanagement $userID');
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    print('Current user $userId');
    if (userID != null) {
      return await Firestore.instance.collection('users').document(userID).get();
    }
    else {
      return await Firestore.instance.collection('users').document(userId).get();
    }
  }

  getCurrentUser() async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    return userId;
  }

  addPost(Name, Des, UserImageUrl, ImageUrl, PhoneNumber, context) async {
    var uuid = new Uuid();
    String PostID;
    bool isliked = false;
    PostID = uuid.v1();
    var date = new DateTime.now();
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    Firestore.instance.collection('/Posts').document('$PostID',).setData({
      'Creation Time': date,
      'Postid':PostID,
      'Name': Name,
      'Userid': userId,
      'User Pic': UserImageUrl,
      'Image Urls': ImageUrl,
      'Description': Des,
      'Like': isliked,
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }).catchError((e) {
      final snackBar = SnackBar(
        content: Text(e.message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  getPosts() async {
    QuerySnapshot Qn = await Firestore.instance.collection("Posts").orderBy(
        "Creation Time", descending: true).getDocuments();
    return Qn.documents;
  }

  getmyPosts(userID)async{
    print('This is in Usermanagement $userID');
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    print('Current user $userId');
    if (userID != null) {
      QuerySnapshot Qn = await Firestore.instance.collection("Posts").where("Userid", isEqualTo: userID).orderBy(
          "Creation Time", descending: true).getDocuments();
      return Qn.documents;
    }
    else {
      QuerySnapshot Qn = await Firestore.instance.collection("Posts").where("Userid", isEqualTo: userId).orderBy(
          "Creation Time", descending: true).getDocuments();
      return Qn.documents;
    }

  }


  storeMessages(UserID, peerId, content) async {
    List<DocumentSnapshot> templist;
    var _list;
    List<Map<dynamic, dynamic>> list = new List();
    String message;
    var Time;
    Firestore.instance
        .collection('Messages')
        .document(UserID) // sender From == current
        .collection(peerId) // receiver  To == PeerID
        .document(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()).setData({
      'From': UserID,
      'To': peerId,
      'Content': content,
      'Time Stamp': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
    });
    Firestore.instance
        .collection('Messages')
        .document(peerId)
        .collection(UserID)
        .document(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()).setData({
      'From': UserID,
      'To': peerId,
      'Content': content,
      'Time Stamp': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
    });
  }

  updateShowPassword(Id,value) async{
    await Firestore
        .instance
        .collection('users')
        .document(Id)
        .updateData({
      'Show Password' : value
    });
  }
}
