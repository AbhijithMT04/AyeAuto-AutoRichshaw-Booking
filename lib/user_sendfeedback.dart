import 'dart:convert';

import 'package:ayeautoo/user_Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main(){
  return runApp(usersendfeedback());
}
class usersendfeedback extends StatefulWidget{
  usersendfeedback_state createState()=>usersendfeedback_state();
}

class usersendfeedback_state extends State<usersendfeedback>{
  final feedback = new TextEditingController();
  String? errormsg;
  bool? error, showprogress;
  bool passwordVisible=true;

  Future _saveDetails(String feed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lid = prefs.getString("lid").toString();
    String url = prefs.getString("url").toString();
    var data = await http.post(
        Uri.parse(url.toString()+"/user_send_feedback"),
        body: {"feed":feed,"lid":lid});

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

        Navigator.push(context, MaterialPageRoute(builder: (context) => userhome()));

      }else{
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
          }, icon: new Icon(Icons.arrow_back,color: Color(0xFFFF4A17),),),
          title: Text('Send Feedback', style: TextStyle(color: Color(0xFFFF4A17))),
          backgroundColor: Colors.black,
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
                      labelText: 'Feedback',
                      hintText: 'Enter Your Feedback',
                      prefixIcon: Icon(Icons.feedback_outlined, color: Color(0xFFFF4A17)),
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
                    controller: feedback,
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
                      child: Text('SEND',
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

                        _saveDetails(feedback.text);
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
