import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Chat.dart';


class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool userFlag = false;
  var users;
  String PhoneNumber,peerId,UserId;

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
        title: Text('Messages'),
      ),
      body: Stack(
        children:<Widget>[
          Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').orderBy("Name", descending: false).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else{
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top:15.0),
                              child: Text("All Users",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,),),
                            ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(8.0),
                          itemBuilder: (context,index) => buildItem(context,snapshot.data.documents[index]),
                          itemCount: snapshot.data.documents.length,
                        ),
                          ],
                        ),
                      );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context,DocumentSnapshot document){
    if(document['User ID'] == UserId){
      print("NO $PhoneNumber");
      return Container();
    }
    else{
      print("yess!");
      return userFlag ? Container(
        child: Padding(
          padding: EdgeInsets.only(top: 15,left: 10),
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
                            borderRadius: BorderRadius.all(Radius.circular(50.5)),
                          ),
                        ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:  EdgeInsets.only(left:15),
                          child: Text(document["Name"],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                        ),
                      ],
                    ),
                      ],
                    ),
                    /*Spacer(),*/
                  ],
                ),
                onTap:()  {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(peerId: document.documentID,peerName: document['Name'], peerAvatar: document['Image Url'],
                )));
                },
              ),
            ],
          ),
        ),
      )
          : new Container();
    }
  }
}