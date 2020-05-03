import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class QuestionPaper extends StatefulWidget {
  @override
  _QuestionPaperState createState() => _QuestionPaperState();
}

class _QuestionPaperState extends State<QuestionPaper> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  var urlString = "https://paper.erudition.co.in/makaut";

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
