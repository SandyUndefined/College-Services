import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:college_services/services/usermanagement.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _desController = new TextEditingController();
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  FocusNode myFocus = FocusNode();
  String Des;
  String _fileName;
  List<String> uploadUrls = [];
  List<Asset> Selectedimages = List<Asset>();
  String _error = 'No Error Dectected';
  double _height;
  double _width;
  bool userFlag = false,images= false,pdf=false;
  Item selectedtype;
  var users;
  Uint8List image;
  StorageReference imageRef =
      FirebaseStorage.instance.ref().child("User Profile Photo");
  String userId, Name, PhoneNumber, UserImageUrl;
  ProgressDialog pr;

  List <Item>type = <Item>[
    const Item('Images', Icon(Icons.image,)),
    const Item('Pdf', Icon(Icons.picture_as_pdf,)),
  ];

  @override
  void dispose() {
    // other dispose methods
    _desController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    UserManagement().getData().then((results) {
      setState(() {
        userFlag = true;
        users = results;
        Name = users['Name'];
        UserImageUrl = users['Image Url'];
        PhoneNumber = users['Phone Number'];
        print(UserImageUrl);
      });
    });
  }

  void _chooseFiles() async {
    if(images){
      loadAssets();
      print("Images");
    }
    else if(pdf){
      print("Pdf");
    }
    else{
      print("select a type");
    }
  }

  Widget buildGridView() {
      return Selectedimages.length != 0 ? GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        children: List.generate(Selectedimages.length, (index) {
          Asset asset = Selectedimages[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      ) : Container();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8,
        enableCamera: true,
        selectedAssets: Selectedimages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#ffbc72",
          actionBarTitleColor: "#ffffff",
          statusBarColor: "#ffbc72",
          lightStatusBar: true,
          actionBarTitle: "Select Images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#00152b",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      Selectedimages = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: userFlag
          ? SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
                children: <Widget>[
              userData(),
              SizedBox(
                height: 30,
              ),
              desBox(),
              SizedBox(
                height: 30,
              ),
              ChooseFiles(),
              SizedBox(
                height: 50,
              ),
                  Flexible(child: buildGridView()),
                  SizedBox(
                height: 30,
              ),
              postButton(),
              SizedBox(
                height: 30,
              ),
            ]),
          )
          : new Container(
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }

  Widget userData() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25, top: 30),
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(UserImageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(50.5)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: _width / 12, top: 25),
          child: userFlag
              ? Text(
                  Name,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                )
              : CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget desBox() {
    return Container(
      padding: EdgeInsets.only(
        left: 28,
        right: 28,
      ),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: _desController,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
        maxLines: 6,
        obscureText: false,
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: new InputDecoration(
          labelText: "Something in mind?",
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          fillColor: Color.fromRGBO(241, 243, 243, 1),
          filled: true,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
        ),
        onChanged: (value) {
          setState(() {
            Des = value;
            print(Des);
          });
        },
      ),
    );
  }

  Widget ChooseFiles() {
    return Container(
      alignment: Alignment.center,
      width: _width / 1.4,
      color: Color.fromRGBO(241, 243, 243, 1),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: Color.fromRGBO(241, 243, 243, 1),
              onPressed: () {
               try{
                 if(selectedtype == null){
                   _scaffoldKey.currentState.showSnackBar(new SnackBar(
                       content: new Text("Please Select File type")
                   ));
                 }
                 else{
                   _chooseFiles();
                 }
               }
               catch(e){
                 print(e);
               }
              },
              textColor: Colors.black45,
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Container(
                alignment: Alignment.center,
                width: _width / 2.2,
                child: Text(
                  "Select Files",
                  style: TextStyle(
                    fontSize: 13.0,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: _height / 18,
            child: VerticalDivider(
              color: Colors.black,
              thickness: 1.5,
            ),
          ),
          DropdownButton<Item>(
            hint: Text("Type"),
            value: selectedtype,
            onChanged: (Item Value) {
              setState(() {
                selectedtype = Value;
                if(selectedtype.name == 'Images'){
                  print("images");
                  setState(() {
                    pdf = false;
                    images=true;
                  });
                }
                else if (selectedtype.name == 'Pdf'){
                  print("pdf");
                  pdf = true;
                  images=false;
                }
                else{
                  print("null");
                }

              });
            },
            items: type.map((Item type){
              return DropdownMenuItem<Item>(
                value: type,
                child: Row(
                  children: <Widget>[
                    type.icon,
                    SizedBox(width: 5,),
                    Text(type.name),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget postButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Color.fromRGBO(0, 21, 43, 1),
      onPressed: () {
        if (Des != null) {
          print('ho gya ');
             pr.show();
              print('Pic uploading');
              UploadImages();
        } else {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text("Please Enter Description")
          ));
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Container(
        alignment: Alignment.center,
        width: _width / 1.7,
        child: Text(
          "Upload Post",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  void UploadImages(){
    for(var imageFile in Selectedimages){
      uploadToFirebase(imageFile).then((downloadUrl) {
        uploadUrls.add(downloadUrl.toString());
        if(uploadUrls.length == Selectedimages.length){
          print("This is in if else $uploadUrls");
          UserManagement().addPost(Name,Des,UserImageUrl,uploadUrls,PhoneNumber, context);
        }
      }).catchError((onError){
        print("This is error $onError");
      });
    }
  }

  Future uploadToFirebase(Asset asset) async {
    print("object");
    DateTime date = new DateTime.now();
    var Date = DateFormat('EEE d MMM kk:mm:ss').format(date);
    ByteData byteData = await asset.getByteData(quality: 60);
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference storageRef = FirebaseStorage.instance.ref().child("User Posts").child('$PhoneNumber').child('$Date').child('$date');
    StorageUploadTask uploadTask = storageRef.putData(imageData);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return storageTaskSnapshot.ref.getDownloadURL();
  }
 }

