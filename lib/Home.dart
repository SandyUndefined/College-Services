import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:college_services/SideBar.dart';
import 'package:college_services/pages/upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:college_services/pages/Homepage.dart';
import 'package:college_services/pages/messages.dart';
import 'package:college_services/pages/notification.dart';

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
}


