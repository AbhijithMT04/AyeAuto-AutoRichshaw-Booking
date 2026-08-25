import 'dart:convert';

import 'package:ayeautoo/Login.dart';
import 'user_Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main(){
  return runApp(register_user());
}
class register_user extends StatefulWidget{
  register_user_state createState() => register_user_state();
}

class register_user_state extends State<register_user>{
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

    var data = await http.post(Uri.parse(url.toString()+"/user_register"),
        body: {"name":Uname,"phone":Uphone,"email":Uemail,"place":Uplace,"pin":Upin,"post":Upost,"password":Upassword,"confirm_pass":Uconfirm});

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          leading: IconButton(onPressed: () { Navigator.push(
              context, MaterialPageRoute(builder: (context) => login()));
          }, icon: new Icon(Icons.arrow_back),),
          title: Text('User Registration', style: TextStyle(color: Color(0xFFFF4A17))),
          backgroundColor: Colors.black,
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
                        labelText: 'User Name',
                        hintText: 'Enter Your Name',
                        prefixIcon: Icon(Icons.person, color: Color(0xFFFF4A17)),
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
                      controller: name,

                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        labelText: 'Phone',
                        hintText: 'Enter Your Phone',
                        prefixIcon: Icon(Icons.phone, color: Color(0xFFFF4A17)),
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
                      controller: phone,

                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Your email',
                        prefixIcon: Icon(Icons.email_outlined, color: Color(0xFFFF4A17)),
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
                      controller: email,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        labelText: 'Place',
                        hintText: 'Enter Your place',
                        prefixIcon: Icon(Icons.place_outlined, color: Color(0xFFFF4A17)),
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
                      controller: place,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        labelText: 'Pin',
                        hintText: 'Enter Your pin',
                        prefixIcon: Icon(Icons.pin_drop, color: Color(0xFFFF4A17)),
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
                      controller: pin,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        labelText: 'Post',
                        hintText: 'Enter Your post',
                        prefixIcon: Icon(Icons.local_post_office, color: Color(0xFFFF4A17)),
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

                      controller: post,
                    ),
                  ),Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Your post',
                        prefixIcon: Icon(Icons.password, color: Color(0xFFFF4A17)),
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
                    ),
                  ),Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                        hintText: 'Enter Your post',
                        prefixIcon: Icon(Icons.password, color: Color(0xFFFF4A17)),
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
                      controller: confirm_pass,
                    ),
                  ),




                  Padding(padding: EdgeInsets.all(20),
                    child: SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        // textColor: Colors.white,
                        // color: Colors.blue,
                        child: Text('SIGNUP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Button text color black
                          ),),
                        onPressed: (){
                          print("k");
                          _saveDetails(name.text, phone.text,email.text,place.text,pin.text,post.text,password.text,confirm_pass.text);
                        },
                        style: ElevatedButton.styleFrom(
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
