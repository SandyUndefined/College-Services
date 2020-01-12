import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:college_services/responsive.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'otp_screen.dart';


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

  String phoneNumber;
  String smsCode;
  String VerifyId;

  File _Image;

  bool _large;
  bool _medium;
  Decoration _pinDecoration;

  TextEditingController _name = new TextEditingController();
  TextEditingController _phnNumber = new TextEditingController();
  TextEditingController _rollNumber = new TextEditingController();
  TextEditingController _college = new TextEditingController();
  TextEditingController _course = new TextEditingController();
  TextEditingController _sem = new TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  FocusNode _focusNodePassword = FocusNode();
  bool _obsecure = false;

  ProgressDialog pr;
  String basename;
  bool isValid = false;

  Future<Null> validate(StateSetter updateState) async {
    print("in validate : ${_phnNumber.text.length}");
    if (_phnNumber.text.length == 10) {
      updateState(() {
        isValid = true;
      });
    }
  }

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
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: <Widget>[
              userProfileBorder(),
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

  // ClipOval for User Profile Pictures.
  Widget userProfileBorder(){
    return Container(
      width: 150,
      height: 150,
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
    );
  }

  // Default Image for userProfile
  Widget userProfile(){
    return GestureDetector (
      child: (_Image!=null)?Image.file(_Image,fit: BoxFit.fill,):
      Image.asset('assets/images/user_upload.png'),
      onTap: getImage,
    );
  }

  //Getting Image from gallery and cropping it.
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
            /*activeWidgetColor: Colors.black,*/
            activeControlsWidgetColor: Color.fromRGBO(255,188,114, 1),
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

  //Uploading profile photo to firebase Storage
  Future uploadPic(context) async{
    String filename = "7318724249";
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("User Profile Photo").child(filename);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_Image);
    await uploadTask.onComplete;
    setState(() {
      print("le le re baba Done");
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
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextField(
        controller: _name,
        obscureText: false,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: "Full Name",
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          fillColor: Color.fromRGBO(241, 243, 243, 1),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.0)
          ),
        ),
      ),
    );
  }


  Widget phn_number(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextField(
        onChanged: (value){
          this.phoneNumber = value;
          print(this.phoneNumber);
        },
        controller: _phnNumber,
        obscureText: false,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: "Phone Number",
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          fillColor: Color.fromRGBO(241, 243, 243, 1),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.0)
          ),
        ),
      ),
    );
  }


  Widget roll_number(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextField(
        controller: _rollNumber,
        obscureText: false,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: "Roll Number",
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          fillColor: Color.fromRGBO(241, 243, 243, 1),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.0)
          ),
        ),
      ),
    );
  }


  Widget college(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextField(

        controller: _college,
        obscureText: false,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          enabled: false,
          labelText: "Siliguri Institute of Technology",
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          fillColor: Color.fromRGBO(241, 243, 243, 1),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.0)
          ),
        ),
      ),
    );
  }


  Widget coursename(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextField(
        controller: _course,
        obscureText: false,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: "Course",
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          fillColor: Color.fromRGBO(241, 243, 243, 1),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.0)
          ),
        ),
      ),
    );
  }


  Widget sem(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
     child:TextField(
       controller: _sem,
       obscureText: false,
       keyboardType: TextInputType.number,
       style: TextStyle(
         fontSize: 14,
       ),
       decoration: InputDecoration(
         labelText: "Sem",
         alignLabelWithHint: true,
         labelStyle: TextStyle(
           color: Colors.black,
         ),
         fillColor: Color.fromRGBO(241, 243, 243, 1),
         filled: true,
         border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(22.0)
         ),
       ),
     ),
    );
  }


  Widget buildSignUpButton(){
    return RaisedButton(
      shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),),
      color: Color.fromRGBO(255,188,114, 1),
      onPressed: () {
        /*pr.show();*/
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OTPScreen(
                        mobileNumber:
                        _phnNumber
                            .text,
                      ),
                ));

        /*uploadPic(context);*/
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

