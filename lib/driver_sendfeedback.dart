import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'driver_Home.dart';

void main() {
  return runApp(sendfeedback());
}

class sendfeedback extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: sendfeedback(),
    );
  }
  sendfeedback_state createState() => sendfeedback_state();
}

class sendfeedback_state extends State<sendfeedback> {
  final feedback = new TextEditingController();
  String? errormsg;
  bool? error, showprogress;
  bool passwordVisible = true;

  Future _saveDetails(String feed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = prefs.getString("url");
    var lid = prefs.getString("lid");
    var data = await http.post(
      Uri.parse(url.toString() + "/and_sendfeedback"),
      body: {"Feedback": feed, "lid": lid},
    );

    var jsondata = json.decode(data.body);
    if (jsondata["res"] == "false") {
      setState(() {
        print("kkkkkkkkkkkkk");
      });
    } else {
      if (jsondata["res"] == "true") {
        setState(() {
          print("lllllllllllllll");
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => driverhome()));
      } else {
        print("lllllllllllllllllllllllllllll");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () { Navigator.push(
            context, MaterialPageRoute(builder: (context) => driverhome()));
          }, icon: new Icon(Icons.arrow_back, color: Color(0xFFFF4A17)),),
        title: Text(
          'FEEDBACK',
          style: TextStyle(color: Color(0xFFFF4A17)),
        ),
        backgroundColor: Color(0xFFFFF0EB),
        elevation: 6,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  errorText: error == true ? "": "*",

                  labelText: 'Feedback',
                  hintText: 'Enter Your Feedback',
                  prefixIcon: Icon(Icons.feedback_outlined, color: Color(0xFFFF4A17)),
                  filled: true,
                  fillColor: Colors.black,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF4A17), width: 2.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFFF4A17)),
                  ),
                  hintStyle: TextStyle(color: Color(0xFFFF4A17)), // Hint text color
                  labelStyle: TextStyle(color: Color(0xFFFF4A17)), // Label text color
                ),
                controller: feedback,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  child: Text(
                    'SEND',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Button text color black
                    ),
                  ),
                  onPressed: () {
                    print("k");
                    int flg = 0;
                    if(feedback.text.isEmpty){
                      setState(() {
                        error = false;
                      });
                      flg++;
                    }
                    if(flg == 0) {
                      _saveDetails(feedback.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.deepOrange.shade300),

                    // primary: Color(0xFFFF4A17), // Button background #FF4A17
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Joke1 {
  final String id;
  Joke1(this.id);
}
