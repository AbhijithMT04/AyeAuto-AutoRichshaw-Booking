import 'package:flutter/material.dart';

void main(){
  runApp(driverchatwithuser());
}
class driverchatwithuser extends StatelessWidget {
  const driverchatwithuser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: driverchatwithusersub(),
    );
  }
}

class driverchatwithusersub extends StatefulWidget {
  const driverchatwithusersub({Key? key}) : super(key: key);

  @override
  State<driverchatwithusersub> createState() => _driverchatwithusersubState();
}

class _driverchatwithusersubState extends State<driverchatwithusersub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Hoooiii"),
    );
  }
}
