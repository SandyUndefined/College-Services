import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:flutter/material.dart';
import 'Chat.dart';


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
                  return ListView.separated(

                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (context,index) => buildItem(context,snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    separatorBuilder: ((context,index){
                      return Divider();
                    }),
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
      return Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: RaisedButton(
                shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),),
                color: Color.fromRGBO(255,188,114, 1),
                textColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: Container(
                  alignment: Alignment.center,
                  width: 250,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                onPressed: ()=>{},
              ),
            ),
          ],
        ),
      );
    }
    else{
      print("yess!");
      return userFlag ? Container(

        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            side: BorderSide(
              color: Colors.grey,
              width: .5,
            ),
          ),
          elevation: 2,
          child:Padding(
            padding: EdgeInsets.only(top: 10),
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
                        padding:  EdgeInsets.only(left:25),
                        child: Text(document["Name"],style: TextStyle(fontWeight: FontWeight.w800,fontSize: 14),),
                      ),
                    ],
                  ),
                  onTap:()  {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(peerId: document.documentID, peerAvatar: document['Image Url'],
                  )));
                  },
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