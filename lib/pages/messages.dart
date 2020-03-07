import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:flutter/material.dart';


class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool userFlag = false;
  var users;
  String PhoneNumber;

  @override
  void initState() {
    super.initState();
    UserManagement().getData().then((results) {
      setState(() {
        userFlag = true;
        users = results;
        PhoneNumber = users['Phone Number'];
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
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else{
                  return ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (context,index) => buildItem(context,snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
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
    if(document['Phone Number']== PhoneNumber){
      print("NO");
      return Container();
    }
    else{
      print("yess!");
      return userFlag ? Container(
        child: Card(
          elevation: 2,
          child:Padding(
            padding: EdgeInsets.only(left:10.0,top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  child: new Row(
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
                      Padding(
                        padding:  EdgeInsets.only(left:15),
                        child: Text(document["Name"],style: TextStyle(fontWeight: FontWeight.w800,fontSize: 14),),
                      ),
                    ],
                  ),
                  onTap:() => print("Working"),
                ),
              ],
            ),
          ),
        ),
      )
          : new Container();
    }
  }
}