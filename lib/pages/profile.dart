import 'dart:typed_data';
import 'package:college_services/services/usermanagement.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  Uint8List image;
  StorageReference imageRef = FirebaseStorage.instance.ref().child("User Profile Photo");
  bool userFlag = false;
  var users;
  String userId,Name,Email,PhoneNumber,RollNumber,College,Course,Semester;

Future getImage(context) async{
  int maxSize = 10*1024*1024;
  String filename = PhoneNumber;
  imageRef.child(filename).getData(maxSize).then((data){
    setState(() {
      image = data;
      print("ho ga bhai");
    });
  }).catchError((e){
    print(e.message);
  });
  print(filename);
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserManagement().getData().then((results) {
    setState(() {
      userFlag = true;
       users = results;
       Name = users['Name'];
       Email = users['Email'];
      PhoneNumber = users['Phone Number'];
      RollNumber = users['Roll Number'];
      College = users['College'];
      Course = users['Course'];
      Semester = users['Semester'];
      getImage(context);

    });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left:30.0,top:30.0),
        child: Column(
          children:<Widget>[
            Profileimage(),
            SizedBox(height: 30,),
            name(),
            SizedBox(height: 30,),
            email(),
            SizedBox(height: 30,),
            Phone(),
            SizedBox(height: 30,),
            RollNumbers(),
            SizedBox(height: 30,),
            Colleges(),
            SizedBox(height: 30,),
            Courses(),
            SizedBox(height: 30,),
            Sem(),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  Widget Profileimage(){
    return Container(
      padding: EdgeInsets.only(left: 0.0,top: 20.0),
      child:
        (image!=null)?Image.memory(image,fit: BoxFit.fill,):
      CircularProgressIndicator(),
    );
  }

  Widget name() {
    return Container(
      padding: EdgeInsets.only(left: 0.0,top: 20.0),
      child: Center(
            child: userFlag ?
            Text(Name,
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),
          )
        :CircularProgressIndicator(),


      ),
    );
  }

  Widget email() {
    return Container(
      padding: EdgeInsets.only(left: 0.0,top: 20.0),
      child: Center(
        child: userFlag ?
        Text(Email,
          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),
        )
            :CircularProgressIndicator(),
      ),
    );
  }

  Widget Phone(){
    return Container(
      padding: EdgeInsets.only(left: 0.0,top: 20.0),
      child: Center(
        child: userFlag ?
        Text(PhoneNumber,
          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),
        )
            :CircularProgressIndicator(),
      ),
    );
  }

  Widget RollNumbers(){
    return Container(
      padding: EdgeInsets.only(left: 0.0,top: 20.0),
      child: Center(
        child: userFlag ?
        Text(RollNumber,
          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),
        )
            :CircularProgressIndicator(),
      ),
    );
  }

  Widget Colleges(){
    return Container(
      padding: EdgeInsets.only(left: 0.0,top: 20.0),
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),
                ),
                SizedBox(
                  width: 5,
                ),
                userFlag ?
                Text(Course,
                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),
                ):CircularProgressIndicator(),
              ],
          ),
        ],
      ),
    );
  }

  Widget Courses(){
    return Container(
      padding: EdgeInsets.only(left: 0.0,top: 20.0),
      child: Center(
        child: userFlag ?
        Text(Course,
          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),
        )
            :CircularProgressIndicator(),
      ),
    );
  }

  Widget Sem(){
    return Container(
      padding: EdgeInsets.only(left: 0.0,top: 20.0),
      child: Center(
        child: userFlag ?
        Text(Semester,
          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),
        )
            :CircularProgressIndicator(),
      ),
    );
  }



}