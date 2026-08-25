import 'package:ayeautoo/driver_updateamount.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'driver_Home.dart';
import 'driver_view_verifiedrequest.dart';

void main(){
  runApp(driverviewrequestandverify());
}
class driverviewrequestandverify extends StatelessWidget {
  const driverviewrequestandverify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: driverviewrequestandverifysub(),
    );
  }
}

class driverviewrequestandverifysub extends StatefulWidget {
  const driverviewrequestandverifysub({Key? key}) : super(key: key);

  @override
  State<driverviewrequestandverifysub> createState() => _driverviewrequestandverifysubState();
}

class _driverviewrequestandverifysubState extends State<driverviewrequestandverifysub> {
  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lid = prefs.getString("lid").toString();
    String url = prefs.getString("url").toString();
    var data = await http.post(Uri.parse(url.toString()+"/and_view_request"),
        body: {"lid":lid}
    );

    var jsonData = json.decode(data.body);
//    print(jsonData);
    List<Joke> jokes = [];
    for (var joke in jsonData["message"]) {
      print(joke);
      Joke newJoke = Joke(
        joke["id"].toString(),
        joke["username"],
        joke["email"].toString(),
        joke["Date"].toString(),
        joke["From"].toString(),
        joke["To"].toString(),
        joke["Amount"].toString(),
      );
      jokes.add(newJoke);
    }
    return jokes;
  }

  // mark this driver not-available since they accepted a ride request
  Future<void> _setDriverNotAvailable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString("url");
    String? lid = prefs.getString("lid");

    if (url == null || lid == null) return;

    try {
      final response = await http.post(
        Uri.parse("$url/set_as_not_available"),
        body: {"lid": lid},
      );

      if (response.statusCode == 200) {
        await prefs.setString("status", "not available");
      }
    } catch (e) {
      print("Set unavailable error $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () { Navigator.push(
            context, MaterialPageRoute(builder: (context) => driverhome()));
        }, icon: new Icon(Icons.arrow_back, color: Color(0xFFFF4A17)),),
        title: Text('Requests', style: TextStyle(color: Color(0xFFFF4A17))),
        backgroundColor: Colors.black,
        elevation: 6,
        centerTitle: true,
        // backgroundColor:TColor.primary,
        // title: Text(widget.title),
      ),
      body:


      Container(


        child:
        FutureBuilder(
          future: _getJokes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
//              print("snapshot"+snapshot.toString());
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.deepOrange.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            SizedBox(height: 10),
                            _buildRow("Id:", snapshot.data[index].id.toString()),
                            _buildRow("Name:", snapshot.data[index].username.toString()),
                            _buildRow("Email:", snapshot.data[index].email.toString()),
                            _buildRow("Date:", snapshot.data[index].Date.toString()),
                            _buildRow("From:", snapshot.data[index].From.toString()),
                            _buildRow("To:", snapshot.data[index].To.toString()),
                            _buildRow("Amount:", snapshot.data[index].Amount.toString()),
                            Row(
                              children: [
                                ElevatedButton(
                                  child: Text('Approve',style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Button text color black
                                  ),),
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(color: Colors.deepOrange.shade300),

                                    shadowColor: Colors.red.shade900,
                                    // primary: Color(0xFFFF4A17), // Button background #FF4A17
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: Colors.deepOrange.shade300),

                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                  ),
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String rid = snapshot.data[index].id.toString();
                                    prefs.setString("rid", rid);

                                    // driver accepted a request -> go not-available
                                    await _setDriverNotAvailable();

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => updateamount()));



                                  },
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  child: Text('Reject',style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Button text color black
                                  ),),
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(color: Colors.deepOrange.shade300),

                                    shadowColor: Colors.red.shade900,
                                    // backgroundColor: Color(0xFFFF4A17), // Button background #FF4A17
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                  ),
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    var url = prefs.getString("url");
                                    String rid = snapshot.data[index].id.toString();
                                    String? lid= prefs.getString("lid");
                                    var data = await http.post(Uri.parse(url.toString() + "/and_reject_request"),
                                        body: {"rid": rid,"lid":lid});
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

                                        Navigator.push(context, MaterialPageRoute(builder: (context) => driverhome()));

                                      }else{
                                        print("lllllllllllllllllllllllllllll");
                                      }
                                    }






                                  },
                                ),
                              ],
                            ),


                          ],
                        ),
                      ),
                    ),
                  );
                },
              );


            }
          },



        ),





      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(
      //         builder: (context)=>user_send_complaint(
      //         )));
      //   },
      //
      // ),
    );
  }
  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Joke {
  final String id;
  final String username;

  final String email;
  final String Date;
  final String From;
  final String To;
  final String Amount;




  Joke(this.id,this.username, this.email,this.Date,this.From,this.To,this.Amount);
//  print("hiiiii");
}