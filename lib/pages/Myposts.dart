import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/pages/Homepage.dart';
import 'package:college_services/services/usermanagement.dart';
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
  String userID, Name, UserUrl, Des;
  bool userFlag = false;
  var users, creationTime;

  @override
  void initState() {
    print(widget.uid);
    super.initState();
    _data = UserManagement().getmyPosts(widget.uid);
    if (_data == null || _data == 0) {
      setState(() {
        userFlag = true;
      });
    } else {
      print(_data);
    }
  }

  navigateToDetail(DocumentSnapshot post, String uid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                  uid: uid,
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
        child: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data.length == 0) {
                return Container(
                  child: Center(
                    child: Text('No Post Yet'),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, top: 10),
                          child: InkWell(
                            onTap: () => navigateToDetail(
                              snapshot.data[index],
                              snapshot.data[index].data["Userid"],
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
                                          image: NetworkImage(snapshot
                                              .data[index].data["User Pic"]),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.5)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        snapshot.data[index].data["Name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 60, bottom: 10),
                                  child: Text(
                                    DateFormat.yMMMd().add_jm().format(
                                        DateTime.parse(snapshot
                                            .data[index].data["Creation Time"]
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
                                      snapshot.data[index].data["Description"],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 75, top: 15, bottom: 8),
                                  child: Text(
                                    snapshot.data.length.toString() +
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
                                      child: IconButton(
                                          onPressed: () {
                                            print(snapshot.data[index]);
                                            print(snapshot
                                                .data[index].data["Like"]);
                                          },
                                          icon:
                                              snapshot.data[index].data["Like"]
                                                  ? Icon(Icons.favorite,
                                                      color: Colors.redAccent,
                                                      size: 23.0)
                                                  : Icon(Icons.favorite_border,
                                                      color: Colors.redAccent,
                                                      size: 23.0)),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.chat_bubble_outline,
                                          color: Colors.blue,
                                          size: 23.0,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {},
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
