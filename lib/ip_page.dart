import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Login.dart';

void main() {
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.orange, // Default, we'll override it
      brightness: Brightness.dark,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Color(0xFFFF4A17)), // #FF4A17 orange-red
      ),
    ),
    home: ip_page(),
  ));
}

class ip_page extends StatefulWidget {
  @override
  ip_page_State createState() => ip_page_State();
}

class ip_page_State extends State<ip_page> {
  final ipaddress = TextEditingController(text: '127.0.0.1');
  String? errormsg;
  bool? error, showprogress;
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter IP Address', style: TextStyle(color: Color(0xFFFF4A17))),
        backgroundColor: Colors.black, // AppBar background black
        elevation: 6,
        centerTitle: true,
      ),
      body: Center( // This will center the body content
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
              children: <Widget>[
                // Main Card container for inputs
                Card(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.black, // Card background black
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Your IP Address",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF4A17), // Text color #FF4A17
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),

                        // IP Address input field
                        TextField(
                          controller: ipaddress,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'IP Address',
                            hintText: 'Enter your IP address',
                            prefixIcon: Icon(Icons.public, color: Color(0xFFFF4A17)), // Icon color #FF4A17
                            filled: true,
                            fillColor: Colors.black, // TextField background black
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFF4A17), width: 2.0), // Border color #FF4A17
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFFF4A17)),
                            ),
                            hintStyle: TextStyle(color: Color(0xFFFF4A17)), // Hint text color #FF4A17
                            labelStyle: TextStyle(color: Color(0xFFFF4A17)), // Label text color #FF4A17
                          ),
                          style: TextStyle(color: Colors.white), // White text in the field
                        ),
                        SizedBox(height: 20),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (ipaddress.text.isEmpty) {
                                setState(() {
                                  errormsg = "Please enter a valid IP address";
                                  error = true;
                                });
                                return;
                              }

                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString("ip", ipaddress.text);
                              prefs.setString("url", "http://${ipaddress.text}:5000");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => login()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              // primary: Color(0xFFFF4A17), // Button background #FF4A17
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Button text color black
                              ),
                            ),
                          ),
                        ),
                        if (error != null && error == true)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              errormsg ?? '',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Joke1 {
  final String id;
  Joke1(this.id);
}
