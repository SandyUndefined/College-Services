import 'dart:io';
import 'dart:typed_data';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  List<Asset> images = List<Asset>();

  double _height;
  double _width;
  bool userFlag = false;
  var users;
  Uint8List image;
  StorageReference imageRef = FirebaseStorage.instance.ref().child("User Profile Photo");
  String userId,Name,PhoneNumber;

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

  Future<void> choosefiles() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 30,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#ffbc72",
          lightStatusBar: true,
          statusBarColor: '#ffbc72',
          actionBarTitle: "Select Images",
          actionBarTitleColor: "#000",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#fff",
          selectionLimitReachedText: "only 30 images applicable"
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  upload(fileName, filePath) {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserManagement().getData().then((results) {
      setState(() {
        userFlag = true;
        users = results;
        Name = users['Name'];
        PhoneNumber = users['Phone Number'];
        getImage(context);

      });
    });
  }



  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
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
            SizedBox(height: 30,),
            postButton(),
            SizedBox(height: 30,)

          ],
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
                child: (image!=null)?Image.memory(image,fit: BoxFit.contain,):
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
      child:TextFormField(
      /*validator: validatedes,*/
      keyboardType: TextInputType.multiline,
      maxLines: 6,
      /*controller: controller,*/
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
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      onChanged: (value){
      },
      ),
    );
  }
  Widget ChooseFiles(){
    return RaisedButton(
      shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(5.0),),
      color: Color.fromRGBO(241, 243, 243, 1),
      onPressed: choosefiles,
      textColor: Colors.black45,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Container(
        alignment: Alignment.center,
        width: _width/2.2,
        child: Text(
          "Choose files",
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
      onPressed: (){},
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

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }



}