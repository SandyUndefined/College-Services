import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:college_services/SideBar.dart';
import 'package:college_services/pages/upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:college_services/pages/Homepage.dart';
import 'package:college_services/pages/messages.dart';
import 'package:college_services/pages/notification.dart';
import 'package:college_services/pages/profile.dart';

class HomePage extends StatefulWidget {
 _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int currentTab = 0;
  final List<Widget> screens = [
    Home(),
    Messages(),
    Notify(),
    SideBar(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            createHeader(),
            createDrawerItem(
                icon:Icons.person,
                text:'Profile',
                onTap: () =>
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Profile()),)
            ),
            createDrawerItem(
                icon:Icons.people,
                text:'Friends',
                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Home()),),
            ),
            Divider(),
            createDrawerItem(
                icon:Icons.description,
                text:'Notice',
                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Home()),),
            ),
            createDrawerItem(
                icon:Icons.event_note,
                text:'Exam Schedule',
                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Home()),),
            ),
            createDrawerItem(
                icon:Icons.library_books,
                text:'Pervious Year Question',
                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Home()),),
            ),
            createDrawerItem(
                icon:Icons.event,
                text:'Events',
                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Home()),),
            ),
            Divider(),
            createDrawerItem(
                icon:Icons.settings,
                text:'Settings',
                onTap: () =>
                Navigator.push(context,MaterialPageRoute(builder: (context) => Home()),)
            ),
            createDrawerItem(
                icon:Icons.arrow_forward,
                text:'Logout',
                onTap: () => logout(),
            ),
          ],
        ),
      ),
      body: screens[currentTab],
      floatingActionButton: FloatingActionButton(
        backgroundColor:Color.fromRGBO(255,188,114, 1),
        child: Icon(Icons.add_box),
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => Upload()),);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CircleBottomNavigation(
        barHeight: 65,
        circleSize: 45,
        barBackgroundColor: Color.fromRGBO(0,21,43,1),
        initialSelection: currentTab,
        inactiveIconColor: Colors.grey[350],
        textColor: Colors.white,
        hasElevationShadows: false,
        tabs: [
          TabData(
            title: 'Home',
            icon: Icons.home,
            iconSize: 25,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          TabData(
            title: 'Messages',
            icon: Icons.message,
            iconSize: 25,
            fontSize: 12,
            fontWeight: FontWeight.bold,),
          TabData(
            title: 'Notification',
            icon: Icons.notifications,
            iconSize: 25,
            fontSize: 12,
            fontWeight: FontWeight.bold,),
          TabData(
            title: 'More',
            icon: Icons.menu,
            iconSize: 25,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ],
        onTabChangedListener: (index) => setState(() => currentTab = index),
      ),
    );
  }

  Widget createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: CircleAvatar(
          backgroundColor: Color.fromRGBO(0,21,43,1),
          child: Text(
            "A",
            style: TextStyle(fontSize: 40.0),
          ),
        ),
      decoration: BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
              image: AssetImage("assets/images/2.jpg"),
              fit: BoxFit.cover)
      ),
     /* decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image:  AssetImage('assets/images/2.jpg'))),*/


    );
  }

  Widget createDrawerItem({IconData icon,String text,GestureTapCallback onTap}){
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  void logout() async{
    _firebaseAuth.signOut();
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => new LogIn()));
  }
}


