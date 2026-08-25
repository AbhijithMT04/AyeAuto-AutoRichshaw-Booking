import 'dart:convert';
import 'dart:math';
import 'package:ayeautoo/user_Home.dart';
import 'package:ayeautoo/user_register.dart';
import 'package:ayeautoo/widget/BazierContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Driver_reg.dart';
import 'driver_Home.dart';
import 'driver_register.dart';
import 'widget/primary_form_field.dart';


void main() {
  return runApp(login());
}

class login extends StatefulWidget {
  login_State createState() => login_State();
}

class login_State extends State<login> {
  final username = new TextEditingController(text: 'doflamingo3vil@gmail.com');
  final password = new TextEditingController(text: 'Raju123');
  String? errormsg;
  bool? error = true, showprogress;
  bool passwordVisible=true;
  Future _saveDetails(String Username, String Password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = prefs.getString("url");
    var data = await http.post(Uri.parse(url.toString()+"/and_login"),
        body: {"username":Username,"password":Password});

    var jsondata = json.decode(data.body);
    print(jsondata);


    if(jsondata["res"]=="false"){
      setState(() {
        // print("kk/kkkkkkkkkkk");
      });
    }
    else{
      if(jsondata["res"]=="true"){
        setState(() {
          // print("lllllllllllllll");
        });
        String type=jsondata["type"].toString();
        if(type=="driver"){
          String uid = jsondata["lid"].toString();
          String status = jsondata["sts"].toString();
          // print(uid);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("lid",uid);
          prefs.setString("status",status);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>driverhome()));
        }
        else{

          String uid = jsondata["lid"].toString();
          // print(uid);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("lid",uid);

          Navigator.push(context, MaterialPageRoute(builder: (context)=>userhome()));
        }


      }else{
        print("lllllllllllllllllllllllllllll");
      }
    }
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'AYE',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)
          ),
          children: [
            TextSpan(
              text: 'AUTO',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),

          ]),
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        title: Text('Login', style: TextStyle(color: Color(0xFFFF4A17))),
        backgroundColor: Colors.black87, // AppBar background black
        elevation:6,
        centerTitle: true,
      ),
      body: 
      Container(
        height: height,
        child: Stack(
            children: <Widget>[
        Positioned(
        top: -height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: BezierContainer()),
         Center(
          child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            // _title(),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  decoration: InputDecoration(
                    errorText: error == true ? "": "*",
                      labelText: 'User Name',
                      hintText: 'Enter Your Name',
                      prefixIcon: Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.black,
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
                  controller: username,
                  style: TextStyle(color: Colors.white),
        
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    errorText: error == true ? "": "*",
                      prefixIcon: Icon(Icons.password),
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      suffixIcon: IconButton(icon: Icon(passwordVisible?Icons.visibility:Icons.visibility_off), onPressed: () {
                        setState(() {
                          passwordVisible=!passwordVisible;
                        });
                      },),
                    filled: true,
                    fillColor: Colors.black,
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
                  controller: password,
                  style: TextStyle(color: Colors.white),
        
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF303030), // Button background #FF4A17
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    // textColor: Colors.white,
                    // color: Colors.blue,
                    child: Text('Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70, // Button text color black
                      ),
                    ),
        
                    onPressed: (){
                      print("k");
                      int flg = 0;
                      if(username.text.isEmpty){
                        setState(() {
                          error = false;
                        });
                        flg++;
                      }
                      if(password.text.isEmpty){
                        setState(() {
                          error = false;
                        });
                        flg++;
                      }
        
                      // else{
                      //   setState(() {
                      //     error = true;
                      //   });
                      // }
        
                      if(flg == 0) {
                        _saveDetails(username.text, password.text);
                      }
        
        
                    },
                  ),
                ),
              ),
        
              Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    // Register button
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF303030), // Button background #FF4A17
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('Driver Signup!!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70, // Button text color black
                      ),),
                    onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => driverregistartion()));
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    // Register button
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF303030), // Button background #FF4A17
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(' User Signup!!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70, // Button text color black
                      ),),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => register_user()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
            ),
        ]
      ),
    )
    );
  }
}

class Joke1 {
  final String id;
  Joke1(this.id);
}
