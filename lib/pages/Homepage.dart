import 'package:college_services/pages/profile.dart';
import 'package:college_services/services/fullscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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

  List<NetworkImage> _listOfImages = <NetworkImage>[];
  final TextEditingController textEditingController = new TextEditingController();
  final FocusNode focusNode = new FocusNode();
  String userID, usersId,profilePic,comments,Name;
  var users;
bool userFlag = false;
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
    userID = widget.uid;
    getCurrentusers();
    UserManagement().getProfileData(usersId).then((data)async{
      setState(() {
        userFlag = true;
        users = data;
        profilePic = users['Image Url'];
        Name = users['Name'];
      });
    });
  }

  getCurrentusers() async {
    String id = usersId = (await FirebaseAuth.instance.currentUser()).uid;
    setState(() {
      usersId = id;
    });
  }

  comment(String content,String Postid,String UserPic,String Name) async{
    if(content != ''){
      /*textEditingController.clear();*/
      UserManagement().addComments(content,Postid,UserPic,Name);
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
      body: userFlag ? ListView(
        children: <Widget>[
         Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: UserManagement().getPosts(widget.postId),
              builder: (_, doc) {
                if (doc.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  final List<DocumentSnapshot> documents = doc.data.documents;
                  return ListView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (_, indexs) {
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
                                            image: NetworkImage(documents[indexs].data["User Pic"]),
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
                                          documents[indexs].data["Description"],
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
                                        DateTime.parse(documents[indexs]
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
                                    child: GridView.count(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                        crossAxisCount: 2,
                                      // ignore: missing_return
                                      children:List.generate(documents[indexs].data["Image Urls"].length, (index){
                                           _listOfImages = [];
                                           for(int i = 0;i<documents[indexs]
                                               .data["Image Urls"].length;i++){
                                             _listOfImages.add(NetworkImage(documents[indexs]
                                                 .data["Image Urls"][i]));
                                             return GestureDetector(
                                               onTap: (){
                                                 Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                   return FullScreen(imageURL: documents[indexs]
                                                       .data["Image Urls"][index]);
                                                 }));
                                               },
                                               child: Container(
                                                 width: 400,
                                                 height: 400,
                                                 child: Image.network(
                                                     documents[indexs]
                                                     .data["Image Urls"][index],
                                                   loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                                     if (loadingProgress == null) return child;
                                                     return Center(
                                                       child: CircularProgressIndicator(
                                                         value: loadingProgress.expectedTotalBytes != null ?
                                                         loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                                             : null,
                                                       ),
                                                     );
                                                   },
                                                 ),
                                               ),
                                             );
                                           }
                                      }),
                                    )
                                ),
                                Divider(),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                              onPressed: () async {
                                                if (documents[indexs].data['Likes']
                                                        [usersId] !=
                                                    true) {
                                                  await UserManagement()
                                                      .updateLikes(documents[indexs]
                                                          .data['Postid']);
                                                } else {
                                                  await UserManagement()
                                                      .updateDislike(
                                                          documents[indexs]
                                                              .data['Postid']);
                                                }
                                              },
                                              icon: documents[indexs].data['Likes']
                                                          [usersId] ==
                                                      true
                                                  ? Icon(Icons.favorite,
                                                      color: Colors.redAccent,
                                                      size: 23.0)
                                                  : Icon(Icons.favorite_border,
                                                      color: Colors.redAccent,
                                                      size: 23.0)),
                                          documents[indexs].data['Likes']
                                                      ['Like Count'] ==
                                                  0
                                              ? Text("")
                                              : Text(documents[indexs]
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
                                                print("message box");
                                              },
                                              icon: Icon(
                                                Icons.chat_bubble,
                                                color: Colors.blue,
                                                size: 23.0,
                                              ),
                                            ),
                                            documents[indexs].data
                                            ['Comment Count'] ==
                                                0
                                                ? Text("")
                                                : Text(documents[indexs]
                                                .data['Comment Count']
                                                .toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          Fluttertoast.showToast(msg: "Not Avilable");
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
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(profilePic),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(50.5)),
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:12.0),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  suffixIcon: IconButton(
                                                    onPressed: () async {
                                                     await comment(
                                                         textEditingController.text,
                                                         documents[indexs].data['Postid'],
                                                         profilePic,
                                                       Name,
                                                     );
                                                     textEditingController.clear();
                                                     FocusScope.of(context).requestFocus(FocusNode());
                                                    },
                                                      icon: Icon(Icons.arrow_forward),
                                                  ),
                                                  hintText: "Add a comment",
                                                  alignLabelWithHint: true,
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  filled: false,
                                                ),
                                                obscureText: false,
                                                controller: textEditingController,
                                                focusNode: focusNode,
                                                autofocus: false,
                                                maxLines: 3,
                                                minLines: 1,
                                                keyboardType: TextInputType.text,
                                                style: TextStyle(height: 1.0),
                                                textCapitalization: TextCapitalization.sentences,
                                                textInputAction: TextInputAction.done,
                                                toolbarOptions: ToolbarOptions(
                                                  cut: true,
                                                  copy: false,
                                                  selectAll: true,
                                                  paste: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: 30,
                                      ),
                                      Center(
                                        child: documents[indexs].data
                        ['Comment Count'] ==
                        0 ? Text(
                                          "Wow, such empty",
                                          style: TextStyle(color: Colors.black26),
                                        ) : Comments(documents[indexs].data['Postid']),
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
        ),
  ],) : Center(child: CircularProgressIndicator()),
    );
  }

  Widget Comments(String PostId) {
    return StreamBuilder<QuerySnapshot>(
      stream: UserManagement().getCommentsStream(PostId),
      builder: (_,docs) {
        if (docs.connectionState == ConnectionState.waiting) {
          return Container();
        }
        else {
          final List<DocumentSnapshot> documents = docs.data.documents;
          return ListView.builder(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (_, index) {
                return ListTile(
          leading:  CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(documents[index].data["Image Url"]), // no matter how big it is, it won't overflow
          ),
          title: Text(documents[index].data["Name"],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800),),
          subtitle:  Text(documents[index].data["Comment"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                  trailing: Text(DateFormat.yMMMd().add_jm().format(DateTime.parse(documents[index].data["Time Stamp"].toDate().toString())),style: TextStyle(fontSize: 8,fontWeight: FontWeight.w600),),
        );
              }
          );
        }
      }
    );
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
              if(documents.length == 0){
                return Center(child: Text("Wow, such empty",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),);
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
                                  documents[index].data["Image Urls"].length.toString() +
                                      " File uploaded",
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
                                        Fluttertoast.showToast(msg: "Not Avilable");
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
