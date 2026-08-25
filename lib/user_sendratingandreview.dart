import 'dart:convert';

import 'package:ayeautoo/user_Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main(){
  return runApp(send_rating());
}
class send_rating extends StatelessWidget {
  const send_rating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: send_rating_state(),
    );
  }

}

class send_rating_state extends StatefulWidget {
  const send_rating_state({Key? key}) : super(key: key);

  @override
  State<send_rating_state> createState() => _send_rating_stateState();
}

class _send_rating_stateState extends State<send_rating_state> {
  final rating = new TextEditingController();
  final review = new TextEditingController();
  String? errormsg;
  String rt="";

  bool? error, showprogress;
  bool passwordVisible=true;
  // Future _saveDetails(String rating,String review) async {
  Future _saveDetails(String rating, String review) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lid = prefs.getString("lid").toString();
    String did = prefs.getString("did").toString();
    String url = prefs.getString("url").toString();
    print("RT  "+rt.toString());
    var data = await http.post(
        Uri.parse(url.toString()+"/send_ratingandreview"),
        body: {"rating": rt.toString(),"review":review,"lid":lid,"did":did});

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
          }, icon: new Icon(Icons.arrow_back),),
          title: Text('Rating & Review',
              style: TextStyle(color: Color(0xFFFF4A17))),
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
                        labelText: 'Review',
                        hintText: 'Enter Your review',
                        prefixIcon: Icon(Icons.reviews_outlined, color: Color(0xFFFF4A17)),
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
                    controller: review,
                    style: TextStyle(color: Colors.white),

                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(15),
                  child: RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      setState(() {
                        rt=rating.toString();
                      });

                    },
                  )
                ),

                // Padding(
                //   padding: EdgeInsets.all(15),
                //   child: TextField(
                //
                //     decoration: InputDecoration(
                //         labelText: 'Rating',
                //         hintText: 'Enter Your Rating',
                //         prefixIcon: Icon(Icons.star_half_outlined, color: Color(0xFFFF4A17)),
                //       filled: true,
                //       fillColor: Colors.black,
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: Color(0xFFFF4A17), width: 2.0), // Border color #FF4A17
                //       ),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(12),
                //         borderSide: BorderSide(color: Color(0xFFFF4A17)),
                //       ),
                //       hintStyle: TextStyle(color: Color(0xFFFF4A17)), // Hint text color #FF4A17
                //       labelStyle: TextStyle(color: Color(0xFFFF4A17)), // Label text color #FF4A17
                //     ),
                //
                //     controller: rating,
                //     style: TextStyle(color: Colors.white),
                //
                //   ),
                // ),




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
                        side: BorderSide(color: Color(0xFFFF4A17)),

                        // primary: Color(0xFFFF4A17), // Button background #FF4A17
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: (){
                        print("k");
                        _saveDetails(rt.toString(), review.text.toString());
                        // _saveDetails(review.text, rating.text);
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
