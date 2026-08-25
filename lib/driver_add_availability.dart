import 'package:flutter/material.dart';


void main(){
  runApp(driveraddavailability());
}

class driveraddavailability extends StatelessWidget {
  const driveraddavailability({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: driveraddavailabilitysub(),
    );
  }
}

class driveraddavailabilitysub extends StatefulWidget {
  const driveraddavailabilitysub({Key? key}) : super(key: key);

  @override
  State<driveraddavailabilitysub> createState() => _driveraddavailabilitysubState();
}

class _driveraddavailabilitysubState extends State<driveraddavailabilitysub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Text("Kooi.."),
    );
  }
}
