import 'package:flutter/material.dart';
import 'ip_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.orange,
      brightness: Brightness.dark,
    ),
    home: ip_page(),
  ));
}