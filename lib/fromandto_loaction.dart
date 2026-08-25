import 'dart:convert';
import 'package:ayeautoo/user_Home.dart';
import 'package:ayeautoo/user_view_availableDrivers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'driver_Home.dart';

void main(){
  runApp(fromtolocation());
}
class fromtolocation extends StatefulWidget {
  const fromtolocation({Key? key}) : super(key: key);

  @override
  State<fromtolocation> createState() => _fromtolocationState();
}

class _fromtolocationState extends State<fromtolocation> {
  final from = new TextEditingController();
  final to = new TextEditingController();
  String? errormsg;
  bool? error, showprogress;
  bool passwordVisible=true;
  Future _saveDetails(String From, String To) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = prefs.getString("url");
    var lid = prefs.getString("lid");
    var did = prefs.getString("did");
    var data = await http.post(Uri.parse(url.toString()+"/book_driver"),
        body: {"from":From,"to":To,"lid":lid,"did":did});

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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>userhome()));
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
            context, MaterialPageRoute(builder: (context) => userviewavailabilitydrivers()));
        }, icon: new Icon(Icons.arrow_back, color: Color(0xFFFF4A17)),),
        title: Text('Location', style: TextStyle(color: Color(0xFFFF4A17))),
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
                  errorText: error == true ? "": "*",

                  labelText: 'From',
                    hintText: 'Enter Your from location',
                    prefixIcon: Icon(Icons.my_location_outlined, color: Color(0xFFFF4A17)),
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
                style: TextStyle(color: Colors.white), // White text in the field


                controller: from,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  errorText: error == true ? "": "*",

                  labelText: 'To',
                    hintText: 'Enter To location',
                    prefixIcon: IconButton(icon: Icon(Icons.location_on_outlined, color: Color(0xFFFF4A17)), onPressed: () {
                      setState(() {
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
                style: TextStyle(color: Colors.white), // White text in the field

                controller: to,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  // textColor: Colors.white,
                  // color: Colors.blue,
                  child: Text('Book',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Button text color black
                    ),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => userhome()));

                    print("k");
                    int flg = 0;
                    if(from.text.isEmpty){
                      setState(() {
                        error = false;
                      });
                      flg++;
                    }
                    if(to.text.isEmpty){
                      setState(() {
                        error = false;
                      });
                      flg++;
                    }
                    if(flg == 0) {
                      _saveDetails(from.text, to.text);
                    }
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
        ),
      ),
    );
  }
}

class Joke1 {
  final String id;
  Joke1(this.id);
}
