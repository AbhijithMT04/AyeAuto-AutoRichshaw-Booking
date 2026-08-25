import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryFormField extends StatelessWidget {
  final String lblText;
  final String hntText;

  const PrimaryFormField({
    Key? key,
    required this.lblText,
    required this.hntText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: lblText,
        hintText: hntText,
        prefixIcon: Icon(Icons.email_outlined),
        filled: true,
        fillColor: Colors.black,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Color(0xFFFF4A17), width: 2.0), // Border color #FF4A17
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFF4A17)),
        ),
        hintStyle: TextStyle(color: Color(0xFFFF4A17)),
        // Hint text color #FF4A17
        labelStyle:
            TextStyle(color: Color(0xFFFF4A17)), // Label text color #FF4A17
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
