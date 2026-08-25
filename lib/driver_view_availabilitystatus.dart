import 'package:flutter/material.dart';

void main(){
  runApp(driverviewavailabilitystatus());
}

class driverviewavailabilitystatus extends StatelessWidget {
  const driverviewavailabilitystatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: driverviewavailable(),
    );
  }
}

class driverviewavailable extends StatefulWidget {
  const driverviewavailable({Key? key}) : super(key: key);

  @override
  State<driverviewavailable> createState() => _driverviewavailableState();
}

class _driverviewavailableState extends State<driverviewavailable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Heloooooo...."),
    );
  }
}
