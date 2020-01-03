import 'package:college_services/responsive.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;


  CustomTextField(
      {this.hint,
        this.textEditingController,
        this.keyboardType,
        this.icon,
        this.obscureText= false,
      });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium=  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(22.0),
      child: TextField(
        controller: textEditingController,
        obscureText: false,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: hint,
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
}
