import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _desController = new TextEditingController();
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  FocusNode myFocus = FocusNode();
  String Des;
  String _fileName;
  String ImageUrl;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multipick = true;
  double _height;
  double _width;
  bool userFlag = false;
  var users;
  Uint8List image;
  StorageReference imageRef = FirebaseStorage.instance.ref().child("User Profile Photo");
  String userId,Name,PhoneNumber,UserImageUrl;
  ProgressDialog pr;

  Future getImage(context) async{
    int maxSize = 10*1024*1024;
    String filename = PhoneNumber;
    imageRef.child(filename).getData(maxSize).then((data){
      setState(() {
        image = data;
        print("ho ga bhai");
      });
    }).catchError((e){
      print(e.message);
    });
    print(filename);
  }

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
        getImage(context);

      });
    });
  }

  void _chooseFiles() async{
    try {
        print('Saab');
        _path = null;
        _paths = await FilePicker.getMultiFilePath(
            type: FileType.ANY, fileExtension: _extension);
    }catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _path != null
          ? _path.split('/').last
          : _paths.keys.toString().replaceAll("(", "").replaceAll(")", "");
    });

  }



  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
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
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Container(
        child:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            userData(),
            SizedBox(height: 30,),
            desBox(),
            SizedBox(height: 30,),
            ChooseFiles(),
            SizedBox(height: 50,),
            new Builder(
              builder: (BuildContext context) => _loadingPath
                  ? Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: const CircularProgressIndicator())
                  : _paths != null
                  ? new Container(
                padding: const EdgeInsets.only(bottom: 30.0),
                height: MediaQuery.of(context).size.height * 0.50,
                child: new Scrollbar(
                    child: new ListView.separated(
                      itemCount: _paths != null && _paths.isNotEmpty
                          ? _paths.length
                          : 1,
                      itemBuilder: (BuildContext context, int index ) {
                        final bool isMultiPath =
                            _paths != null && _paths.isNotEmpty;
                        final String name = 'File $index : ' +
                            (isMultiPath
                                ? _paths.keys.toList()[index]
                                : _fileName );
                        final path = isMultiPath
                            ? _paths.values.toList()[index].toString()
                            : _path;

                        return new ListTile(
                          title: new Text(
                            name,
                          ),
                          subtitle: new Text(path),
                        );
                        },
                      separatorBuilder:
                          (BuildContext context, int index) =>
                      new Divider(),
                    )),
              )
                  : new Container(),
            ),
            SizedBox(height: 30,),
            postButton(),
            SizedBox(height: 30,),

          ]
        ),
        ),
      ),
    );

  }
  Widget userData(){
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25,top: 30),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Center(
                child: (image!=null)?Image.network(UserImageUrl,fit: BoxFit.contain,):
                Icon(
                  Icons.person,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: _width/12,top: 25),
          child: userFlag ?
          Text(Name,
            style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),
          )
              :CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget desBox(){
    return Container(
      padding: EdgeInsets.only(left: 28,right: 28,),
      child:TextField(
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
        onChanged: (value){
            setState(() {
              Des = value;
              print(Des);
            });
        },
      ),
    );
  }
  Widget ChooseFiles(){
    return RaisedButton(
      shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(5.0),),
      color: Color.fromRGBO(241, 243, 243, 1),
      onPressed: () => _chooseFiles(),
      textColor: Colors.black45,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Container(
        alignment: Alignment.center,
        width: _width/2.2,
        child: Text(
          "Select Files to Upload",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
  Widget postButton(){
    return RaisedButton(
      shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),),
      color: Color.fromRGBO(0,21,43,1),
      onPressed:  () {
        if (Des != null) {
          print('ho gya ');
          pr.show();
          Future.delayed (Duration(seconds: 3), ).then((onValue){
            if(pr.isShowing())
            {
              print('Pic uploading');
              uploadToFirebase();
              UploadPost();
              Future.delayed(Duration(seconds: 3),).then((onValue){
                pr.hide();
              });
            }
          }
          );
        }
        else
        {
          print('Nahi hua....pic is not uploading');
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Container(
        alignment: Alignment.center,
        width: _width/1.7,
        child: Text(
          "Upload Post",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }


  void UploadPost() async{
   UserManagement().addPost(Name,Des,UserImageUrl,ImageUrl,PhoneNumber, context);
  }

  void uploadToFirebase() async{
    _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
  }

  void upload(fileName, filePath) async{
    DateTime date = new DateTime.now();
    var Date = DateFormat('EEE d MMM kk:mm:ss').format(date);
    StorageReference storageRef = FirebaseStorage.instance.ref().child("User Posts").child('$PhoneNumber').child('$Date').child('$date');
    final StorageUploadTask uploadTask = storageRef.putFile(File(filePath));
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    print(url);
    setState(() {
      ImageUrl = url;
      print("le le re baba Done");
      print(ImageUrl);
    });

  }

}