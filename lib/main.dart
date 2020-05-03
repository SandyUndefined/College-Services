import 'package:college_services/wrapper.dart';
import 'package:flutter/material.dart';

import 'authProvider.dart';
import 'authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(255, 188, 114, 1),
        ),
        home: Wrapper(),
      ),
    );
  }
}
