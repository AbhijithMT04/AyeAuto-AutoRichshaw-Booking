import 'dart:convert';

import 'package:ayeautoo/Login.dart';
import 'package:ayeautoo/user_Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main(){
  return runApp(userprofile());
}
class userprofile extends StatefulWidget{
  userprofile_state createState() => userprofile_state();
}

class userprofile_state extends State<userprofile>{
  final name = new TextEditingController();
  final phone = new TextEditingController();
  final email = new TextEditingController();
  final place = new TextEditingController();
  final pin = new TextEditingController();
  final post = new TextEditingController();
  final password = new TextEditingController();
  final confirm_pass = new TextEditingController();


  String? errormsg;
  bool? error, showprogress;
  bool passwordVisible=true;
  Future _saveDetails(String Uname, String Uphone,String Uemail,String Uplace,String Upin,String Upost,String Upassword,String Uconfirm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = prefs.getString("url");
    var lid = prefs.getString("lid");

    var data = await http.post(Uri.parse(url.toString()+"/userprofile_updatepost"),
        body: {"lid":lid,"name":Uname,"phone":Uphone,"email":Uemail,"place":Uplace,"pin":Upin,"post":Upost,"password":Upassword,"confirm_pass":Uconfirm});

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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>login()));
        //user shared preference to save data
      }else{
        print("lllllllllllllllllllllllllllll");
      }
    }
  }

  Future _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lid = prefs.getString("lid").toString();
    String url = prefs.getString("url").toString();
    var data = await http.post(Uri.parse(url.toString()+"/user_viewprofileandupdate"),
        body: {"lid":lid}
    );

    var jsonData = json.decode(data.body);
    print(jsonData);

    setState(() {
      name.text=jsonData["Name"];
      phone.text=jsonData["Phone"];
      email.text=jsonData["Email"];
      place.text=jsonData["Place"];
      pin.text=jsonData["Pin"];
      post.text=jsonData["Post"];
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJokes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          leading: IconButton(onPressed: () { Navigator.push(
              context, MaterialPageRoute(builder: (context) => userhome()));
          }, icon: new Icon(Icons.arrow_back,color: Color(0xFFFF4A17),),),
          title: Text('User Profile', style: TextStyle(color: Color(0xFFFF4A17))),
          backgroundColor: Color(0xFFFFF0EB),
          elevation: 6,
          centerTitle: true,


        ),

        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        errorText: error == true ? "": "*",

                        labelText: 'User Name',
                        hintText: 'Enter Your Name',
                        prefixIcon: Icon(Icons.person, color: Color(0xFFFF4A17)),
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
                      controller: name,
                      style: TextStyle(color: Colors.black),


                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        errorText: error == true ? "": "*",

                        labelText: 'Phone',
                        hintText: 'Enter Your Phone',
                        prefixIcon: Icon(Icons.phone, color: Color(0xFFFF4A17)),
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
                      controller: phone,
                      style: TextStyle(color: Colors.black),


                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        errorText: error == true ? "": "*",

                        labelText: 'Email',
                        hintText: 'Enter Your email',
                        prefixIcon: Icon(Icons.email_outlined, color: Color(0xFFFF4A17)),
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
                      controller: email,
                      style: TextStyle(color: Colors.black),

                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        errorText: error == true ? "": "*",

                        labelText: 'Place',
                        hintText: 'Enter Your place',
                        prefixIcon: Icon(Icons.place_outlined, color: Color(0xFFFF4A17)),
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
                      controller: place,
                      style: TextStyle(color: Colors.black),

                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        errorText: error == true ? "": "*",

                        labelText: 'Pin',
                        hintText: 'Enter Your pin',
                        prefixIcon: Icon(Icons.pin_drop, color: Color(0xFFFF4A17)),
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
                      controller: pin,
                      style: TextStyle(color: Colors.black),

                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        errorText: error == true ? "": "*",

                        labelText: 'Post',
                        hintText: 'Enter Your post',
                        prefixIcon: Icon(Icons.local_post_office, color: Color(0xFFFF4A17)),
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

                      controller: post,
                      style: TextStyle(color: Colors.black),

                    ),
                  ),




                  Padding(padding: EdgeInsets.all(20),
                    child: SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        // textColor: Colors.white,
                        // color: Colors.blue,
                        child: Text('UPDATE',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Button text color black
                          ),),
                        onPressed: (){
                          print("k");
                          int flg = 0;
                          if(name.text.isEmpty){
                            setState(() {
                              error = false;
                            });
                            flg++;
                          }
                          if(phone.text.isEmpty){
                            setState(() {
                              error = false;
                            });
                            flg++;
                          }
                          if(email.text.isEmpty){
                            setState(() {
                              error = false;
                            });
                            flg++;
                          }
                          _saveDetails(name.text, phone.text,email.text,place.text,pin.text,post.text,password.text,confirm_pass.text);
                        },
                        style: ElevatedButton.styleFrom(
                          // primary: Color(0xFFFF4A17), // Button background #FF4A17
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Color(0xFFFFF0EB),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),






                ],
              )
          ),
        )
    );
  }
}

class Joke1 {
  final String id;
  Joke1(this.id);
}
