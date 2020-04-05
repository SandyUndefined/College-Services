import 'package:college_services/pages/EditProfile.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Setting extends StatefulWidget {
  final String uid;
  Setting({this.uid});
  @override
  _SettingState createState() => _SettingState();
}


class _SettingState extends State<Setting> {
  bool showPhn = false,userFlag = false;
  var users;
  String UserID;
  @override
  void initState() {
    super.initState();
    UserID = widget.uid;
    print('This is user ID in settings $UserID');
    UserManagement().getProfileData(UserID).then((results) async{
      setState(() {
        userFlag = true;
        users = results;
        showPhn = users['Show Password'];
        print('This is show phoneNumber $showPhn');
      });
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: userFlag ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "General",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              ),
            ),
            Card(
              child: SwitchListTile(
                value: showPhn,
                title: Text("Show My Phone Number"),
                onChanged: (bool value){
                  setState(() {
                    showPhn = value;
                    print('this is in switchListTile $showPhn');
                    UserManagement().updateShowPassword(UserID,value);
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Profile Setting",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Edit Profile"),
                onTap: (){
                  print("Working");
                  Navigator.push(context, MaterialPageRoute( builder:(context) => EditProfile()));
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Theme",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: SwitchListTile(
                  value: true,
                  title: Text("Default"),
                  onChanged: (value){},
                ),
                subtitle: SwitchListTile(
                  value: false,
                  title: Text("Dark"),
                  onChanged: (value){},
                ),
              ),
            ),
          ],
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
