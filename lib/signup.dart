import 'dart:io';
import 'dart:ui';
import 'package:college_services/login.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:college_services/services/responsive.dart';
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
  String ImageUrl;

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

  bool ImageDone = false;

  ProgressDialog pr;

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
  Future<String> uploadPic(context) async{
    String filename = phoneNumber;
    StorageReference ref = FirebaseStorage.instance.ref().child("User Profile Photo").child(filename);
    StorageUploadTask uploadTask = ref.putFile(_Image);
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
     setState(() {
       if(url==null){
         print("le le re baba Done");
         print(ImageUrl);
       }
       else{
         ImageUrl = url;
       }
     });
    return ImageUrl;
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
        onChanged: (value){
          setState(() {
            Name = value;
            print(Name);
          });
        },
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
        onChanged: (value){
          setState(() {
            phoneNumber = value;
            print(phoneNumber);
          });
        },
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
        onChanged: (value){
          setState(() {
            Email = value;
            print(Email);
          });
        },
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
        onChanged: (value){
          setState(() {
            Password = value;
            print(Password);
          });
        },
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
        onChanged: (value){
          setState(() {
            ConfirmPassword = value;
            print(ConfirmPassword);
          });
        },
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
        onChanged: (value){
          setState(() {
            RollNumber = value;
            print(RollNumber);
          });
        },
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
        onChanged: (value){
          setState(() {
            Course = value;
            print(Course);
          });
        },
      ),
    );
  }

  Widget sem(){
    return Material(
      borderRadius: BorderRadius.circular(22.0),
     child:TextFormField(
       focusNode: _focussem,
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
       onChanged: (value){
         setState(() {
           Semester = value;
           print(Semester);
         });
       },
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
          uploadPic(context);
          Future.delayed (Duration(seconds: 8), ).then((onValue){
            if(pr.isShowing())
            {
              Signup();
              Future.delayed(Duration(seconds: 3),).then((onValue){
                pr.hide();
              });
            }
          }
          );
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

  String validateName(String value) {
    if (value.isNotEmpty) {
      return null;
    }
    else
      {
        return 'Please enter a name';
      }
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
    if(value.length < 6 ){
      return 'Password must be longer than 6 digit';
    }
    else
      return null;
  }

  String validateconfpsswd(String value) {
    if(value != _password.text)
    {
      return 'Password does not match';

    }
    else
      return null;
  }

  void Signup() async{
    if(_key.currentState.validate()){
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: Email, password: Password).then((signedInUser){
        print('this is my image $ImageUrl');
        print('this is my url');
        UserManagement().storeNewUser(Name,Email,Password,phoneNumber,ImageUrl,RollNumber,Course,Semester,signedInUser.user, context);
      }).catchError((e){
        final snackBar = SnackBar(
          content: Text(e.message),
        );
        Scaffold.of(context).showSnackBar(snackBar);
        print(e);
      });
    }
    else{
      print("nulllllll");
    }
  }

}

