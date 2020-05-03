import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' show get;
import 'package:progress_dialog/progress_dialog.dart';

class FullScreen extends StatefulWidget {
  final String imageURL;

  FullScreen({this.imageURL});

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  bool data = false;
  ProgressDialog pr;
  static int i = 1;

  _dowloadimg() async {
    var url = widget.imageURL;
    print(url);
    var response = await get(url);
    var documentDirectory = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_PICTURES); // For Intrenal storage  /storage/emulated/0/Pictures/College Services
    print(documentDirectory);
    var firstPath = documentDirectory + '/College Services';
    print(firstPath);
    var filePathAndName = documentDirectory + '/College Services/img_${i++}.jpg';
    print(filePathAndName);
    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    print(file2);
    print("Done");
    setState(() {
      data = true;
    });
    if (data) {
      pr.hide();
      print("imaged downloaded");
      Fluttertoast.showToast(msg: "Image downloaded");
      setState(() {
        data = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Download Image"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              color: Colors.black54,
              icon: Icon(Icons.file_download),
              onPressed: () {
                if (data == false) {
                  pr.style(message: 'Downloading...');
                  pr.show();
                  print("send");
                  _dowloadimg();
                }
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: 'imageHero',
          child: Image.network(widget.imageURL, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
