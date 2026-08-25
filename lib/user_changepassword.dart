import 'dart:convert';

import 'package:ayeautoo/Login.dart';
import 'package:ayeautoo/user_Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main(){
  return runApp(userchangepassword());
}
class userchangepassword extends StatefulWidget{
  userchangepassword_state createState()=>userchangepassword_state();
}

class userchangepassword_state extends State<userchangepassword>{
  final current_pass = new TextEditingController();
  final new_pass = new TextEditingController();
  final confirm_pass = new TextEditingController();
  String? errormsg;
  bool? error, showprogress;
  bool passwordVisible=true;
  Future _saveDetails(String current, String newpass,String confirm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = prefs.getString("url");
    var lid = prefs.getString("lid");
    var data = await http.post(
        Uri.parse(url.toString()+"/user_changepass"),
        body: {"current":current,"new_pass":newpass,"confirm":confirm,"lid" :lid});

    var jsondata = json.decode(data.body);
//    if(jsonData["res"])

    if(jsondata["res"]=="false"){
      setState(() {
        print("kkkkkkkkkkkkk");
      });
    }
    else{
      if(jsondata["res"]=="true"){
        setState(() {
          print("lllllllllllllll");
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>login()));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>userchangepassword()));
        print("lllllllllllllllllllllllllllll");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          leading: IconButton(onPressed: () { Navigator.push(
              context, MaterialPageRoute(builder: (context) => userhome()));
          },  icon: new Icon(Icons.arrow_back, color: Color(0xFFFF4A17)),),
          title: Text('Change Password', style: TextStyle(color: Color(0xFFFF4A17))),
          backgroundColor: Colors.black, // AppBar background black
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

                      labelText: 'current password',
                        hintText: 'Enter Your password',
                        prefixIcon: Icon(Icons.password, color: Color(0xFFFF4A17)),
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
                    controller: current_pass,
                    style: TextStyle(color: Colors.white),

                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(

                    decoration: InputDecoration(
                      errorText: error == true ? "": "*",

                      labelText: 'New Password',
                        hintText: 'Enter Your new password',
                        prefixIcon: Icon(Icons.password, color: Color(0xFFFF4A17)),
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
                    controller: new_pass,
                    style: TextStyle(color: Colors.white),

                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(

                    decoration: InputDecoration(
                      errorText: error == true ? "": "*",

                      labelText: 'Confirm password',
                        hintText: 'Enter Your password',
                        prefixIcon: Icon(Icons.password, color: Color(0xFFFF4A17)),
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
                    controller: confirm_pass,
                    style: TextStyle(color: Colors.white),

                  ),
                ),



                Padding(padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      // textColor: Colors.white,
                      // color: Colors.blue,
                      child: Text('Change',
                        style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Button text color black
                      ),),
                      style: ElevatedButton.styleFrom(
                        // primary: Color(0xFFFF4A17), // Button background #FF4A17
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: (){
                        print("k");
                        int flg = 0;
                        if(current_pass.text.isEmpty){
                          setState(() {
                            error = false;
                          });
                          flg++;
                        }
                        if(new_pass.text.isEmpty){
                          setState(() {
                            error = false;
                          });
                          flg++;
                        }
                        if(confirm_pass.text.isEmpty){
                          setState(() {
                            error = false;
                          });
                          flg++;
                        }
                        if(flg == 0) {
                          _saveDetails(current_pass.text, new_pass.text,
                              confirm_pass.text);
                        }
                      },
                    ),
                  ),
                )
              ],
            )
        )
    );
  }
}

class Joke1 {
  final String id;
  Joke1(this.id);
}
