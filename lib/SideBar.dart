import 'package:college_services/Home.dart';
import 'package:college_services/login.dart';
import 'package:college_services/pages/profile.dart';
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


  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container (
          height: _height/0.8,
          width: _width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                header(),
                SizedBox(height: 20.0,),
                bars(),
              ],
            ),
          ),
        ),
    );
  }

  Widget header(){
    return Container(
      width: _width,
      height: 100,
      color: Color.fromRGBO(0,21,43,1),
      child: CircleAvatar(
        child: Text(
          "SANDY",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      /*decoration: BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
              image: AssetImage("assets/images/2.jpg"),
              fit: BoxFit.cover)
      ),*/
      /* decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image:  AssetImage('assets/images/2.jpg'))),*/
    );
  }
  Widget bars(){
    return Container(
          child:Column(
            children: <Widget>[
          profile(),
          SizedBox(height: 20,),
          friends(),
                SizedBox(height: 20,),
          Divider(),
                SizedBox(height: 20,),
          notice(),
          SizedBox(height: 20,),
          schedule(),
          SizedBox(height: 20,),
          questionpaper(),
          SizedBox(height: 20,),
          events(),
                SizedBox(height: 20,),
          Divider(),
                SizedBox(height: 20,),
          settings(),
          SizedBox(height: 20,),
          logout(),
        ],
      ),

    );
  }
  Widget profile(){
    return InkWell(
      child: Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20,),
          child: Icon(
            Icons.person,
            color: Colors.black87,
            size: 25.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: _width/14),
          child: Text("Profile",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
        ),
      ],
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => new Profile()));
      },
    );
  }
  Widget friends(){
    return InkWell(
      child:Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20,),
          child: Icon(
            Icons.people,
            color: Colors.black87,
            size: 25.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: _width/14),
          child: Text("Friends",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
        ),
      ],
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => new HomePage()));
      },
    );
  }
  Widget notice() {
    return InkWell(
      child:Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20,),
          child: Icon(
            Icons.description,
            color: Colors.black87,
            size: 25.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: _width/14),
          child: Text("Notice",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
        ),
      ],
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => new HomePage()));
      },
    );
  }
  Widget schedule(){
    return InkWell(
      child:Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20,),
          child: Icon(
            Icons.event_note,
            color: Colors.black87,
            size: 25.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: _width/14),
          child: Text("Exam Schedule",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
        ),
      ],
      ),
    onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context) => new HomePage()));
    },
    );
  }
  Widget questionpaper(){
    return InkWell(
      child:Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20,),
          child: Icon(
            Icons.library_books,
            color: Colors.black87,
            size: 25.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: _width/14),
          child: Text("Previous Year Questions",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
        ),
      ],
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => new HomePage()));
      },
    );
  }
  Widget events(){
    return InkWell(
      child:Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20,),
          child: Icon(
            Icons.event,
            color: Colors.black87,
            size: 25.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: _width/14),
          child: Text("Events",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
        ),
      ],
      ),
    onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context) => new HomePage()));
    },
    );
  }
  Widget settings(){
    return InkWell(
      child:Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20,),
          child: Icon(
            Icons.settings,
            color: Colors.black87,
            size: 25.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: _width/14),
          child: Text("Settings",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
        ),
      ],
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => new HomePage()));
      },
    );
  }
  Widget logout(){
    return InkWell(
      child:Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20,),
          child: Icon(
            Icons.arrow_forward,
            color: Colors.black87,
            size: 25.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: _width/14),
          child: Text("Logout",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 14),),
        ),
      ],
      ),
      onTap: () => Logout(),
    );
  }

  void Logout() async{
    _firebaseAuth.signOut();
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => new LogIn()));
  }
}