import 'dart:io';
import 'dart:ui';
import 'package:college_services/SignUpComplete.dart';
import 'package:college_services/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:college_services/responsive.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';


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

  String Name;
  String RollNumber;
  String Email;
  String College;
  String Course;
  String Semester;
  String Password;
  String ConfirmPassword;

  File _Image;

  bool _large;
  bool _medium;

  final databaseReference = FirebaseDatabase.instance.reference();

  TextEditingController _name = new TextEditingController();
  TextEditingController _phnNumber = new TextEditingController();
  TextEditingController _rollNumber = new TextEditingController();
  TextEditingController _college = new TextEditingController();
  TextEditingController _course = new TextEditingController();
  TextEditingController _sem = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmpassword = new TextEditingController();
  TextEditingController _email = new TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();

  FocusNode _focuspsswd = FocusNode();
  FocusNode _focusphn = FocusNode();
  FocusNode _focusroll = FocusNode();
  FocusNode _focuscourse = FocusNode();
  FocusNode _focussem = FocusNode();
  FocusNode _focusconfpsswd = FocusNode();
  FocusNode _focusemail = FocusNode();

  bool _obsecure = false;
  bool ImageDone = false;

  ProgressDialog pr;
  String basename;

  bool isValid = false;

  /*Future<Null> validate(StateSetter updateState) async {
    print("in validate : ${_phnNumber.text.length}");
    if (_phnNumber.text.length == 10) {
      updateState(() {
        isValid = true;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

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
              SizedBox(height: 15.0),
              signInTextRow(),
              SizedBox(height: 20.0),
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
       print("hogya!!");
      _Image = croppedFile;
      ImageDone = true;
    });
  }

  //Uploading profile photo to firebase Storage
  Future uploadPic(context) async{
    String filename = phoneNumber;
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
          email(),
          SizedBox(height: _height / 40.0),
          passwrd(),
          SizedBox(height: _height / 40.0),
          confirmpasswrd(),
          SizedBox(height: _height / 40.0),
          roll_number(),
          SizedBox(height: _height / 40.0),
          college(),
          SizedBox(height: _height / 40.0),
          coursename(),
          SizedBox(height: _height / 40.0),
          sem(),
          /*SizedBox(height: 40.0),
          buildSignUpButton(),
          SizedBox(height: 20.0),*/
        ],
      ),
    ),
  );
  }

  Widget name(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextFormField(
        onEditingComplete: (){
         FocusScope.of(context).requestFocus(_focusphn);
        },
        onSaved: (value){
          this.Name = value;
          print(this.Name);
        },
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
        validator: validateName,
      ),
    );
  }

  Widget phn_number(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextFormField(
        focusNode: _focusphn,
        onEditingComplete: (){
          FocusScope.of(context).requestFocus(_focusemail);
        },
        validator: validatephone,
        onSaved: (value){
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

  Widget email(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextFormField(
        focusNode: _focusemail,
        onEditingComplete: (){
          FocusScope.of(context).requestFocus(_focuspsswd);
        },
        validator: (val) => !EmailValidator.validate(val, true)
            ? 'Not a valid email.'
            : null,
        onSaved: (value){
          this.Email = value;
          print(this.Email);
        },
        controller: _email,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: "Email",
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

  Widget passwrd(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextFormField(
        focusNode: _focuspsswd,
        onEditingComplete: (){
          FocusScope.of(context).requestFocus(_focusconfpsswd);
        },
        validator: validatepassword,
        onSaved: (value){
          this.Password = value;
          print(this.Password);
        },
        controller: _password,
        obscureText: true,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: "Password",
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

  Widget confirmpasswrd(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextFormField(
        focusNode: _focusconfpsswd,
        onEditingComplete: (){
          FocusScope.of(context).requestFocus(_focusroll);
        },
        validator: validateconfpsswd,
        onSaved: (value){
          this.ConfirmPassword = value;
          print(this.ConfirmPassword);
        },
        controller: _confirmpassword,
        obscureText: true,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: "Confirm Password",
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
      child: TextFormField(
        focusNode: _focusroll,
        onEditingComplete: (){
          FocusScope.of(context).requestFocus(_focuscourse);
        },
        onSaved: (value){
          this.RollNumber = value;
          print(this.RollNumber);
        },
        validator: validateroll,
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
      child: TextFormField(
       /* onChanged: (value){
          this.phoneNumber = value;
          print(this.phoneNumber);
        },*/
        enabled: false,
        controller: _college,
        obscureText: false,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
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
      child: TextFormField(
        onSaved: (value){
          this.Course = value;
          print(this.Course);
        },
        focusNode: _focuscourse,
        onEditingComplete: (){
          FocusScope.of(context).requestFocus(_focussem);
        },
        validator: validateCourse,
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
     child:TextFormField(
       focusNode: _focussem,
       onSaved: (value){
         this.Semester = value;
         print(this.Semester);
       },
       onEditingComplete: (){
         FocusScope.of(context).requestFocus(new FocusNode());
       },
       validator: validateSem,
       controller: _sem,
       obscureText: false,
       keyboardType: TextInputType.number,
       style: TextStyle(
         fontSize: 14,
       ),
       decoration: InputDecoration(
         labelText: "Semester",
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
        if (_key.currentState.validate() && ImageDone == true) {
          print('ho gya ');
          pr.show();
          Future.delayed(Duration(seconds: 5)).then((value){
            Signup();
            uploadPic(context);
            createRecord();
            pr.hide();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SignUpCompletePage(),
                ));
          });

          _key.currentState.save();
        }
        else
          {
            if(ImageDone == false){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Select an Image'),
              ));
            }
            print('Nahi hua!!!!!!!!!');
          }
       },
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


  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => LogIn()),);
            },
            child: Text(
              "Log In",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Color.fromRGBO(255,188,114, 1), fontSize: _large? 19: (_medium? 17: 15)),
            ),
          )
        ],
      ),
    );
  }

  void createRecord() {
    databaseReference.child(phoneNumber).set({
      'Name' : Name,
      'Password' : Password,
      'Phone Number' : phoneNumber,
      'Roll Number' : RollNumber,
      'College' : 'Siliguri Institute of Technology',
      'Semester' : Semester
    });
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String validatephone(String value) {
    if (value.length == 10) {
      return null;
    }
    else
    {
      return 'Phone Number must contain 10 digit';
    }

  }

  String validateroll(String value) {
    if(value.length == 11){
      return null;
    }
    return 'Please enter a valid roll number';
  }

  String validateCourse(String value) {

    if(value.isEmpty){
      return'Please enter a valid course';
    }
    return null;
  }

  String validateSem(String value) {
    if(value.isEmpty){
      return'Please enter a valid semester';
    }
    return null;
  }

  String validatepassword(String value) {
    if(value.length < 8 ){
      return 'Password must be longer than 8 digit';
    }
    else
      return null;
  }

  String validateconfpsswd(String value) {
    if(Password == ConfirmPassword)
    {
      return null;
    }
    else
      return 'Password does not match';

  }

  void Signup() async{
    if(_key.currentState.validate()){
      _key.currentState.save();
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: Email, password: Password);
      }catch(e){
        print(e.message);
      }
    }
  }

}

