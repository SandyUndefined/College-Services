import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Exams extends StatefulWidget {
  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  var urlString =
      "https://makaut1.ucanapply.com/smartexam/public/routine-details";

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
      print(wvs.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(
          "Exam Schedule",
        ),
      ),
      url: urlString,
      hidden: true,
      withJavascript: true,
      withZoom: false,
    );
  }
}
