import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_services/pages/profile.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bubble/bubble.dart';

class Constants {
  static const String Profile = 'Show Profile';
  static const String Block = 'Block';
  static const List<String> choices = <String>[
    Profile,
    Block,
  ];
}

class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;

  Chat(
      {Key key,
      @required this.peerId,
      @required this.peerName,
      @required this.peerAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(
                          userID: peerId,
                        )));
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(peerAvatar),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    peerName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (ch) {
              if (ch == Constants.Profile) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        userID: peerId,
                      ),
                    ));
              } else if (ch == Constants.Block) {
                Fluttertoast.showToast(msg: "Not Avilable");
              }
            },
            elevation: 4,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String ch) {
                return PopupMenuItem<String>(
                  value: ch,
                  child: Text(ch),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://fsa.zobj.net/crop.php?r=BjF5BN7Sbgdm4bmDfSvzltsVYJrWqnlIDXW06ZPE7_L3FQiOG4Y_Sz3aUVUo5P7jjIHXyR46fJceFafJUIOOh7Hhy7hc5vv_OqhtYiW2dFQkm_2bcESjvL9XKUNVaEL-m4JLL07i2eiy8-ac"),
            fit: BoxFit.cover,
          ),
        ),
        child: new ChatScreen(
          peerId: peerId,
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;

  ChatScreen({Key key, @required this.peerId}) : super(key: key);

  @override
  State createState() => new ChatScreenState(peerId: peerId);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId});

  String peerId, groupId;
  var _formKey = GlobalKey<FormState>();
  String messages;
  var listMessage;
  String UserID;
  SharedPreferences prefs;
  bool isLoading;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    isLoading = false;
    getUserId();
  }

  getUserId() async {
    String UsersID = (await FirebaseAuth.instance.currentUser()).uid;
    setState(() {
      UserID = UsersID;
    });
    print(UserID);
    return UserID;
  }

  void onSendMessage(String content) async {
    if (content != '') {
      textEditingController.clear();
      UserManagement().storeMessages(UserID, peerId, content);
    } else {
      print('This message is null');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: document['From'] == UserID
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              /*padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),*/
              width: 200.0,
              /*decoration: BoxDecoration(
                    color: document['From'] == UserID ? Color.fromRGBO(176, 198, 225,1) : Color.fromRGBO(234, 242, 250,1),
                    borderRadius: BorderRadius.circular(8.0)
                ),*/
              margin: EdgeInsets.only(bottom: 10.0),
              child: Bubble(
                stick: false,
                padding: BubbleEdges.all(8),
                alignment: document['From'] == UserID
                    ? Alignment.topRight
                    : Alignment.topLeft,
                color: document['From'] == UserID
                    ? Color.fromRGBO(176, 198, 225, 1)
                    : Color.fromRGBO(234, 242, 250, 1),
                child: Text(
                  document['Content'],
                  style: TextStyle(color: Color(0xff203152), fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),
                // Input content
                buildInput(),
              ],
            ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              height: 50.0,
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(241, 243, 243, 1), // set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(30.0)), // set rounded corner radius
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 17.0, right: 10),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  validator: (String input) {
                    if (input.isEmpty) {
                      return "message is Empty!";
                    } else {
                      return null;
                    }
                  },
                  onFieldSubmitted: (value) {
                    setState(() {
                      textEditingController.text = value;
                    });
                  },
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  controller: textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  focusNode: focusNode,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 1, right: 10),
            child: Container(
              width: 50,
              height: 50,
              decoration: new BoxDecoration(
                color: Color.fromRGBO(0, 21, 43, 1),
                shape: BoxShape.circle,
              ),
              child: InkWell(
                  child: Icon(
                    Icons.near_me,
                    color: Colors.white,
                  ),
                  onTap: () {
                    onSendMessage(textEditingController.text);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListMessage() {
    print('this is groud ID  on built messages $groupId');
    return Flexible(
      child: peerId == ''
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('Messages')
                  .document(UserID)
                  .collection(peerId)
                  .orderBy('Time Stamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
