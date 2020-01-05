import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:college_services/responsive.dart';
import 'package:college_services/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'Home.dart';

class signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: SignUpScreen (),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{
  double _height;
  double _width;
  double _pixelRatio;
  File _Image;
  bool _large;
  bool _medium;
  TextEditingController _rollnumberController = new TextEditingController();
  TextEditingController _phonenumberController = new TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  FocusNode _focusNodePassword = FocusNode();
  bool _obsecure = false;
  ProgressDialog pr;

  String basename;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(message: 'Showing some progress...');
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
    return Material (
      child: Container (
        height: _height,
        width: _width,
        padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: 180,
                height: 180,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                    boxShadow: [
                    BoxShadow (
                    color: const Color.fromRGBO(255,188,114, 1),
                     offset: Offset(0, 2),
                      blurRadius: 10,
                       ),],
                  border: new Border.all(
                    color: Color.fromRGBO(255,188,114, 1),
                    width: 2,
                  ),
                ),
                child: new ClipOval(
                  child: userProfile(),
                ),
              ),
              /*userProfile(),*/
              /*new Image.asset(),*/
              SizedBox(height: 40.0,),
              form(),
              SizedBox(height: 40.0,),
              buildSignUpButton(),
              SizedBox(height: 20.0),
             // signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userProfile(){
    return GestureDetector (
      child: (_Image!=null)?Image.file(_Image,fit: BoxFit.fill,):
      Image.asset('assets/images/user_upload.png'),
      onTap: getImage,
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Color.fromRGBO(255,188,114, 1),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
    setState(() {
      /*print("hogya!!");*/
      _Image = croppedFile;
    });
  }

  Future uploadPic(context) async{
    String filename = "7318724249";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("User Profile Photo").child(filename);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_Image);
    await uploadTask.onComplete;
    setState(() {
      print("Done");
    });
  }

  Widget form(){
    return Container(
    padding: EdgeInsets.only(
        left: _width / 6.0,
        right: _width / 6.0),
    child: Form(
      key: _key,
      child: Column(
        children: <Widget>[
          name(),
          SizedBox(height: _height / 30.0),
          phn_number(),
          SizedBox(height: _height / 40.0),
          roll_number(),
          SizedBox(height: _height / 40.0),
          college(),
          SizedBox(height: _height / 40.0),
          coursename(),
          SizedBox(height: _height / 40.0),
          sem(),
        ],
      ),
    ),
  );
  }

  Widget name(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "Full Name",
    );
  }
  Widget phn_number(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "Phone Number",
    );
  }
  Widget roll_number(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "Roll Number",
    );
  }
  Widget college(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "College",
    );
  }
  Widget coursename(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "Course",
    );
  }
  Widget sem(){
    return CustomTextField(
      keyboardType: TextInputType.text,
      hint: "Semester",
    );
  }

  Widget buildSignUpButton(){
    return RaisedButton(
      shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),),
      color: Color.fromRGBO(255,188,114, 1),
      onPressed: () {
        pr.show();
        uploadPic(context);
       /* Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home()),);
      */},
      textColor: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Container(
        alignment: Alignment.center,
        width: _width/1.6,
        child: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

}