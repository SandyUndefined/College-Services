import 'package:college_services/login.dart';
import 'package:college_services/pages/Event.dart';
import 'package:college_services/pages/Friends.dart';
import 'package:college_services/pages/Myposts.dart';
import 'package:college_services/pages/Questions.dart';
import 'package:college_services/pages/Schedule.dart';
import 'package:college_services/pages/Setting.dart';
import 'package:college_services/pages/profile.dart';
import 'package:college_services/pages/results.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  double _height;
  double _width;

  bool userFlag = false;
  var users;
  String Name, UserImageUrl, UserID;

  @override
  void initState() {
    super.initState();
    UserManagement().getData().then((results) {
      setState(() {
        userFlag = true;
        users = results;
        Name = users['Name'];
        UserImageUrl = users['Image Url'];
        UserID = users['User ID'];
        print(UserImageUrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: userFlag
          ? Container(
              height: _height / 0.8,
              width: _width,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    header(),
                    SizedBox(
                      height: 20.0,
                    ),
                    bars(),
                  ],
                ),
              ),
            )
          : new Container(
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }

  Widget header() {
    return Container(
      width: _width,
      height: 120,
      alignment: Alignment.topLeft,
      color: Color.fromRGBO(0, 21, 43, 1),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, top: 40),
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(UserImageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(50.5)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, top: 50),
            child: Text(
              Name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget bars() {
    return Container(
      child: Column(
        children: <Widget>[
          profile(),
          SizedBox(
            height: 20,
          ),
          friends(),
          SizedBox(
            height: 20,
          ),
          /* MyPost(),
              SizedBox(height: 20,),*/
          // I will add this feature in next version
          Divider(),
          SizedBox(
            height: 20,
          ),
          notice(),
          SizedBox(
            height: 20,
          ),
          Result(),
          SizedBox(
            height: 20,
          ),
          schedule(),
          SizedBox(
            height: 20,
          ),
          questionpaper(),
          SizedBox(
            height: 20,
          ),
          events(),
          SizedBox(
            height: 20,
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          settings(),
          SizedBox(
            height: 20,
          ),
          logout(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget profile() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Icon(
              Icons.person,
              color: Colors.black87,
              size: 25.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: _width / 14),
            child: Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new Profile()));
      },
    );
  }

  Widget friends() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Icon(
              Icons.people,
              color: Colors.black87,
              size: 25.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: _width / 14),
            child: Text(
              "Friends",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new Friends()));
      },
    );
  }

  Widget MyPost() {
    return Material(
      child: InkWell(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Icon(
                Icons.art_track,
                color: Colors.black87,
                size: 25.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: _width / 14),
              child: Text(
                "My Posts",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyPosts()));
        },
      ),
    );
  }

  Widget notice() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Icon(
              Icons.description,
              color: Colors.black87,
              size: 25.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: _width / 14),
            child: Text(
              "Notice",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
      onTap: () {
        print('Notice is not working for now');
        /*Navigator.push(context, MaterialPageRoute(builder: (context) => new HomePage()));*/
      },
    );
  }

  Widget Result() {
    return Material(
      child: InkWell(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Icon(
                Icons.web,
                color: Colors.black87,
                size: 25.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: _width / 14),
              child: Text(
                "Result",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Results()));
        },
      ),
    );
  }

  Widget schedule() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Icon(
              Icons.event_note,
              color: Colors.black87,
              size: 25.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: _width / 14),
            child: Text(
              "Exam Schedule",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new Exams()));
      },
    );
  }

  Widget questionpaper() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Icon(
              Icons.library_books,
              color: Colors.black87,
              size: 25.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: _width / 14),
            child: Text(
              "Previous Year Questions",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuestionPaper()));
      },
    );
  }

  Widget events() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Icon(
              Icons.event,
              color: Colors.black87,
              size: 25.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: _width / 14),
            child: Text(
              "Events",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new Event()));
      },
    );
  }

  Widget settings() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Icon(
              Icons.settings,
              color: Colors.black87,
              size: 25.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: _width / 14),
            child: Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new Setting(uid: UserID)));
      },
    );
  }

  Widget logout() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.black87,
              size: 25.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: _width / 14),
            child: Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
      onTap: () => Logout(),
    );
  }

  void Logout() async {
    _firebaseAuth.signOut();
    Navigator.of(context).pop();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new LogIn()));
  }
}
