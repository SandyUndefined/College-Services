import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/pages/profile.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  bool userFlag = false;
  var users;
  String PhoneNumber, peerId, UserId;

  @override
  void initState() {
    super.initState();
    UserManagement().getData().then((results) {
      setState(() {
        userFlag = true;
        users = results;
        PhoneNumber = users['Phone Number'];
        UserId = users['User ID'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .orderBy("Name", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.only(
                      left: 8.0, top: 25, right: 8.0, bottom: 15.0),
                  itemBuilder: (context, index) =>
                      buildItem(context, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['User ID'] == UserId) {
      print("NO $PhoneNumber");
      return Container();
    } else {
      print("yess!");
      return userFlag
          ? Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    child: new Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(document["Image Url"]),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.5)),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    document["Name"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        /*Spacer(),*/
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(
                              userID: document.documentID,
                            ),
                          ));
                    },
                  ),
                ],
              ),
            )
          : new Container();
    }
  }
}
