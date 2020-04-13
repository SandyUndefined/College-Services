import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/pages/Homepage.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyPosts extends StatefulWidget {
  final String uid;

  MyPosts({this.uid});

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  Future _data;
  String usersID, userID,Name, UserUrl, Des;
  bool userFlag = false;
  var users, creationTime;

  @override
  void initState() {
    getCurrentusers();
    userID = widget.uid;
    print(widget.uid);
    print(userID);
    super.initState();
  }

  getCurrentusers() async {
    String id = usersID = (await FirebaseAuth.instance.currentUser()).uid;
    setState(() {
      usersID = id;
    });
  }

  navigateToDetail(String postId, String uid,String name) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
              postId: postId,
                  uid: uid,
              name: name,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Posts",
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream:UserManagement().getmyPosts(userID,usersID) ,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else {
                final List<DocumentSnapshot> documents = snapshot.data.documents;
                if(documents.length == 0){
                  return Center(child: Text("Nothing to show",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),);
                }
                return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (_, index) {
                      return Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, top: 10),
                          child: InkWell(
                            onTap: () => navigateToDetail(
                              documents[index].data['Postid'],
                              documents[index].data["Userid"],
                              documents[index].data["Name"],

                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(documents[index].data["User Pic"]),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.5)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Text(
                                          documents[index].data["Name"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                   usersID == documents[index].data["Userid"] ? PopupMenuButton(
                                      elevation:3.2,
                                      itemBuilder: (BuildContext context) => [
                                          PopupMenuItem(
                                            child: ListTile(
                                              title: Text("Delete"),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                return showDialog(
                                                    context: context,
                                                  builder: (BuildContext context){
                                                    return AlertDialog(
                                                      elevation: 24.0,
                                                      content: Text("Are you sure you want to delete this post?"),
                                                      actions: <Widget>[
                                                        FlatButton(child: Text("No"),onPressed: (){
                                                          Navigator.of(context).pop();
                                                        },),
                                                        FlatButton(child: Text("Yes"),onPressed: () async {
                                                         await UserManagement().deleteData(documents[index].data['Postid']);
                                                          Navigator.of(context).pop();
                                                        },),
                                                      ],
                                                    );
                                                  }
                                                );
                                            },)
                                          ),
                                        ],
                                    ) : Container(),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 60, bottom: 10),
                                  child: Text(
                                    DateFormat.yMMMd().add_jm().format(
                                        DateTime.parse(documents[index].data["Creation Time"]
                                            .toDate()
                                            .toString())),
                                    style: TextStyle(
                                        color: Colors.black38, fontSize: 12),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 75, right: 15),
                                    child: Text(
                                      documents[index].data["Description"],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 75, top: 15, bottom: 8),
                                  child: Text(
                                    documents.length.toString() +
                                        "Files uploaded",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Divider(),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                              onPressed: () async {
                                                if (documents[index].data['Likes']
                                                [userID] !=
                                                    true) {
                                                  await UserManagement()
                                                      .updateLikes(
                                                      documents[index]
                                                          .data['Postid']);
                                                } else {
                                                  await UserManagement()
                                                      .updateDislike(
                                                      documents[index]
                                                          .data['Postid']);
                                                }
                                              },
                                              icon: documents[index].data['Likes']
                                              [userID] ==
                                                  true
                                                  ? Icon(Icons.favorite,
                                                  color: Colors.redAccent,
                                                  size: 23.0)
                                                  : Icon(Icons.favorite_border,
                                                  color: Colors.redAccent,
                                                  size: 23.0)
                                          ),
                                          documents[index].data['Likes']
                                          ['Like Count'] ==
                                              0
                                              ? Text("")
                                              : Text(documents[index]
                                              .data['Likes']['Like Count']
                                              .toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:15.0),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              onPressed: () {
                                                navigateToDetail(
                                                  documents[index].data["Postid"],
                                                  documents[index].data["Userid"],
                                                  documents[index].data["Name"],
                                                );
                                              },
                                              icon: Icon(
                                                Icons.chat_bubble_outline,
                                                color: Colors.blue,
                                                size: 23.0,
                                              ),
                                            ),
                                            documents[index].data
                                            ['Comment Count'] ==
                                                0
                                                ? Text("")
                                                : Text(documents[index]
                                                .data['Comment Count']
                                                .toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          print("share");
                                        },
                                        icon: Icon(
                                          Icons.near_me,
                                          color: Colors.blue,
                                          size: 23.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
