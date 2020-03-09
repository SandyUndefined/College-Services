import 'dart:ui';
import 'package:college_services/services/usermanagement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Profile extends StatefulWidget {
  final String userID;
  Profile({this.userID});
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  bool userFlag = false;
  var users;
  String userID,Name,Email,PhoneNumber,Image,RollNumber,College,Course,Semester;
  @override
  void initState() {
    super.initState();
    userID = widget.userID;
    UserManagement().getProfileData(userID).then((results) async{
    setState(() {
      userFlag = true;
       users = results;
       Name = users['Name'];
       Email = users['Email'];
       Image = users['Image Url'];
      PhoneNumber = users['Phone Number'];
      RollNumber = users['Roll Number'];
      College = users['College'];
      Course = users['Course'];
      Semester = users['Semester'];
    });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: userFlag ? SingleChildScrollView(
        child: new Container(
          padding: new EdgeInsets.all(32.0),
          color: Colors.grey.withOpacity(.4),
          child: new Center(
            child: new Column(
              children: <Widget>[
                new Card(
                  child: new Container(
                    width: 360,
                    height: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('http://www.sittechno.org/photogallery/default_photo_details.php?id=167&ck=92a37594e79bb18f4a6124960353f06e'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: new BackdropFilter(
                         filter: new ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2,),
                         child: new Container(
                         decoration: new BoxDecoration(
                         color: Colors.white.withOpacity(0.2),
                            ),
                           child: Padding(
                             padding: const EdgeInsets.only(top:32.0),
                             child: new Column(
                      children: <Widget>[
                        Container(
                          width: 85,
                          height: 85,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(Image),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50.5)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: new Text(Name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black87),),
                        )
                      ],
                    ),
                           ),
                         ),
                       ),
                  ),
                ),
                SizedBox(height: 35,),
                new Card(
                  child: new Container(
                    width: 360,
                    height: 85,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:15.0),
                          child: Icon(
                            Icons.phone,
                            color: Colors.blueAccent,
                            size: 20.0,
                          ),
                        ),
                        VerticalDivider(thickness: 2.0,),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:15.0,left: 5.0),
                              child: Text("PhoneNumber",style: TextStyle(fontSize: 16,color: Colors.grey),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:15.0,left: 5.0),
                              child: Text(PhoneNumber,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4,),
                new Card(
                  child: new Container(
                    width: 360,
                    height: 85,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:15.0),
                          child: Icon(
                            Icons.email,
                            color: Colors.blueAccent,
                            size: 20.0,
                          ),
                        ),
                        VerticalDivider(thickness: 2.0,),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top:15.0,left: 5),
                              child: Text("Email",style: TextStyle(fontSize: 16,color: Colors.grey),),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:15.0,left: 5),
                              child: Text(Email,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4,),
                new Card(
                  child: new Container(
                    width: 360,
                    height: 85,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:15.0),
                          child: Icon(
                            Icons.school,
                            color: Colors.blueAccent,
                            size: 20.0,
                          ),
                        ),
                        VerticalDivider(thickness: 2.0,),
                        new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:15.0,left: 5.0),
                              child: Text("College",style: TextStyle(fontSize: 16,color: Colors.grey),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:15.0,left: 5.0),
                              child: Text(College,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4,),
                new Card(
                  child: new Container(
                    width: 360,
                    height: 85,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:15.0),
                          child: Icon(
                            Icons.library_books,
                            color: Colors.blueAccent,
                            size: 20.0,
                          ),
                        ),
                        VerticalDivider(thickness: 2.0,),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:15.0,left: 5.0),
                              child: Text("Course",style: TextStyle(fontSize: 16,color: Colors.grey),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:15.0,left: 5.0),
                              child: Text(Course,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4,),
                new Card(
                  child: new Container(
                    width: 360,
                    height: 85,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:15.0),
                          child: Icon(
                            Icons.library_books,
                            color: Colors.blueAccent,
                            size: 20.0,
                          ),
                        ),
                        VerticalDivider(thickness: 2.0,),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:15.0,left: 5.0),
                              child: Text("Semester",style: TextStyle(fontSize: 16,color: Colors.grey),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:15.0,left: 5.0),
                              child: Text(Semester,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          :new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}