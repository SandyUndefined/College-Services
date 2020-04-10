import 'package:college_services/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: ListPage(),
    );
  }
}

class DetailPage extends StatefulWidget {
  final String postId;
  final String uid;
  final String name;

  DetailPage({this.postId, this.uid, this.name});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController textEditingController = new TextEditingController();
  final FocusNode focusNode = new FocusNode();
  String userID, usersId;

  navigateToProfile() {
    print(widget.uid);
    userID = widget.uid;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Profile(
                  userID: userID,
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentusers();
  }

  getCurrentusers() async {
    String id = usersId = (await FirebaseAuth.instance.currentUser()).uid;
    setState(() {
      usersId = id;
    });
  }

  comment(String content,String Postid,String Userid) async{
    if(content != ''){
      textEditingController.clear();
      UserManagement().addComments(content,Postid,Userid);
    }
    else
    {
      print('This message is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: UserManagement().getPosts(widget.postId),
          builder: (_, doc) {
            if (doc.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final List<DocumentSnapshot> documents = doc.data.documents;
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (_, index) {
                    return Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => navigateToProfile(),
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(documents[index].data["User Pic"]),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(50.5)),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 25, right: 15),
                                    child: Text(
                                      documents[index].data["Description"],
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 70, bottom: 10),
                              child: Text(
                                DateFormat.yMMMd().add_jm().format(
                                    DateTime.parse(documents[index]
                                        .data["Creation Time"]
                                        .toDate()
                                        .toString())),
                                style: TextStyle(
                                    color: Colors.black38, fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 75, top: 15, bottom: 8),
                              child: Text(
                                documents.length.toString() + "Files uploaded",
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
                                                    [usersId] !=
                                                true) {
                                              await UserManagement()
                                                  .updateLikes(documents[index]
                                                      .data['Postid']);
                                            } else {
                                              await UserManagement()
                                                  .updateDislike(
                                                      documents[index]
                                                          .data['Postid']);
                                            }
                                          },
                                          icon: documents[index].data['Likes']
                                                      [usersId] ==
                                                  true
                                              ? Icon(Icons.favorite,
                                                  color: Colors.redAccent,
                                                  size: 23.0)
                                              : Icon(Icons.favorite_border,
                                                  color: Colors.redAccent,
                                                  size: 23.0)),
                                      documents[index].data['Likes']
                                                  ['Like Count'] ==
                                              0
                                          ? Text("")
                                          : Text(documents[index]
                                              .data['Likes']['Like Count']
                                              .toString())
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
                                            print("message box");
                                          },
                                          icon: Icon(
                                            Icons.chat_bubble,
                                            color: Colors.blue,
                                            size: 23.0,
                                          ),
                                        ),
                                        documents[index].data['Comments']
                                        ['Comment Count'] ==
                                            0
                                            ? Text("")
                                            : Text(documents[index]
                                            .data['Comments']['Comment Count']
                                            .toString())
                                      ],
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
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: TextField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      autofocus: false,
                                      maxLines: 3,
                                      minLines: 1,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(height: 1.0),
                                      textCapitalization: TextCapitalization.sentences,
                                      textInputAction: TextInputAction.newline,
                                      toolbarOptions: ToolbarOptions(
                                        cut: true,
                                        copy: false,
                                        selectAll: true,
                                        paste: true,
                                      ),
                                      onSubmitted: (text) => print(textEditingController.text),
                                    ),
                                    /*TextField(
                                      controller: textEditingController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                     *//* onEditingComplete: () {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                      },*//*
                                      obscureText: false,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      decoration: InputDecoration(
                                        suffixIcon:
                                        IconButton(
                                            icon: Icon(Icons.arrow_forward),
                                            color: Color.fromRGBO(0,21,43,1),
                                            autofocus: true,
                                            onPressed: () {
                                              comment(textEditingController.text,documents[index]
                                                  .data['Postid'],documents[index]
                                                  .data['Userid']);
                                            }),
                                        *//*IconButton(
                                          Icons.near_me,color: Color.fromRGBO(0,21,43,1),onPressed: (){

                                        },),*//*
                                        labelText: "Add comments",

                                        alignLabelWithHint: true,
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        fillColor:
                                            Color.fromRGBO(241, 243, 243, 1),
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                      ),
                                      onSubmitted: (value){
                                        setState(() {
                                          textEditingController.text = value;
                                        });
                                      },
                                      focusNode: focusNode,
                                    ),*/
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Center(
                                    child: documents[index].data['Comments']
                    ['Comment Count'] ==
                    0 ? Text(
                                      "Wow, such empty",
                                      style: TextStyle(color: Colors.black26),
                                    ) : Text(""),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
    );

     /*Scaffold(
      appBar: AppBar(
        title: Text(
          widget.post.data["Name"],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () => navigateToProfile(),
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.post.data["User Pic"]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.5)),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 25, right: 15),
                          child: Text(
                            widget.post.data["Description"],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 75, top: 5),
                    child: Text(
                      DateFormat.yMMMd().add_jm().format(DateTime.parse(widget
                          .post.data["Creation Time"]
                          .toDate()
                          .toString())),
                      style: TextStyle(color: Colors.black38, fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 75, top: 35, bottom: 8),
                    child: Text(
                      widget.post.data.length.toString() + "Files uploaded",
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
                                  if(widget.post.data['Likes'][usersId] != true){
                                    await UserManagement().updateLikes(widget.post.data['Postid']);
                                  }
                                  else{
                                    await UserManagement().updateDislike(widget.post.data['Postid']);
                                  }
                                },
                                icon: widget.post.data['Likes'][usersId] == true ?  Icon(Icons.favorite,
                                    color: Colors.redAccent, size: 23.0) :  Icon(Icons.favorite_border,
                                    color: Colors.redAccent,
                                    size: 23.0)
                            ),
                            widget.post.data['Likes']['Like Count'] == 0 ? Text(""): Text(widget.post.data['Likes']['Like Count'].toString())
                          ],
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.chat_bubble,
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
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            onEditingComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.near_me),
                              labelText: "Add comments",
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Color.fromRGBO(241, 243, 243, 1),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Text(
                            "Wow, such empty",
                            style: TextStyle(color: Colors.black26),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );*/
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isLiked = false;
  var liked;
  String Likes;
  String usersId;

  navigateToDetail(String postId, String uid, String name) {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentusers();
  }

  getCurrentusers() async {
    String id = usersId = (await FirebaseAuth.instance.currentUser()).uid;
    setState(() {
      usersId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: UserManagement().getPostsStream(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final List<DocumentSnapshot> documents = snapshot.data.documents;
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (_, index) {
                    return Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 10),
                        child: InkWell(
                          onTap: () => navigateToDetail(
                            documents[index].data["Postid"],
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
                                        image: NetworkImage(
                                            documents[index].data["User Pic"]),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.5)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      documents[index].data["Name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 60, bottom: 10),
                                child: Text(
                                  DateFormat.yMMMd().add_jm().format(
                                      DateTime.parse(documents[index]
                                          .data["Creation Time"]
                                          .toDate()
                                          .toString())),
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 12),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 75, right: 15),
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
                                                      [usersId] !=
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
                                                        [usersId] ==
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
                                                .toString())
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
                                          documents[index].data['Comments']
                                          ['Comment Count'] ==
                                              0
                                              ? Text("")
                                              : Text(documents[index]
                                              .data['Comments']['Comment Count']
                                              .toString())
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
    );
  }
}
