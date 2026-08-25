import 'dart:convert';

import 'package:ayeautoo/user_Home.dart';
import 'package:ayeautoo/user_view_requesthistory.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main(){
  return runApp(reportdriver());
}
class reportdriver extends StatefulWidget{
  reportdriver_state createState()=>reportdriver_state();

}

class reportdriver_state extends State<reportdriver>{
  final Reason = new TextEditingController();
  String? errormsg;
  bool? error, showprogress;
  bool passwordVisible=true;
  Future _saveDetails(String reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lid = prefs.getString("lid").toString();
    String did = prefs.getString("did").toString();
    String url = prefs.getString("url").toString();
    var data = await http.post(
        Uri.parse(url.toString()+"/reportdriver"),
        body: {"Reason":reason,"lid":lid,"did":did});

    var jsondata = json.decode(data.body);
//    if(jsonData["res"])

    if(jsondata["status"]=="no"){
      setState(() {
        print("kkkkkkkkkkkkk");
      });
    }
    else{
      if(jsondata["status"]=="ok"){
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
          title: Text('Report', style: TextStyle(color: Color(0xFFFF4A17))),
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
                        labelText: 'Reason',
                        hintText: 'Enter Your reason',
                        prefixIcon: Icon(Icons.report_gmailerrorred, color: Color(0xFFFF4A17)),
                      filled: true,
                      fillColor: Color(0xFFFFF0EB),
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
                    controller: Reason,
                    style: TextStyle(color: Colors.white),

                  ),
                ),



                Padding(padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: 100,
                    height: 40,
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
                        side: BorderSide(color: Color(0xFFFF4A17)),

                        // primary: Color(0xFFFF4A17), // Button background #FF4A17
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: (){
                        print("k");
                        _saveDetails(Reason.text);
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
