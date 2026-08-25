import 'package:ayeautoo/user_Home.dart';
import 'package:ayeautoo/user_reportdriver.dart';
import 'package:ayeautoo/user_sendratingandreview.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(userviewrequesthistory());
}

class userviewrequesthistory extends StatelessWidget {
  const userviewrequesthistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userviewrequesthistorysub(),
    );
  }
}

class userviewrequesthistorysub extends StatefulWidget {
  const userviewrequesthistorysub({Key? key}) : super(key: key);

  @override
  State<userviewrequesthistorysub> createState() => _userviewrequesthistorysubState();
}

class _userviewrequesthistorysubState extends State<userviewrequesthistorysub> {
  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lid = prefs.getString("lid").toString();
    String url = prefs.getString("url").toString();
    String foodimage="";
    var data =
    await http.post(Uri.parse(url.toString()+"/user_viewrequesthistory"),
        body: {"lid":lid}
    );

    var jsonData = json.decode(data.body);
//    print(jsonData);
    List<Joke> jokes = [];
    for (var joke in jsonData["message"]) {
      print(joke);
      Joke newJoke = Joke(
        joke["id"].toString(),
        joke["drivername"],
        joke["email"].toString(),
        joke["Date"].toString(),
        joke["From"].toString(),
        joke["To"].toString(),
        joke["amount"].toString(),
        joke["status"].toString(),
        joke["did"].toString(),
      );
      jokes.add(newJoke);
    }
    return jokes;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () { Navigator.push(
            context, MaterialPageRoute(builder: (context) => userhome()));
        }, icon: new Icon(Icons.arrow_back,color: Color(0xFFFF4A17),),),
        title: Text('Request History', style: TextStyle(color: Color(0xFFFF4A17))),
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
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: 10),
                            // _buildRow("Id:", snapshot.data[index].id.toString()),
                            _buildRow("Driver Name:", snapshot.data[index].drivername.toString()),
                            _buildRow("Email:", snapshot.data[index].email.toString()),
                            _buildRow("Date:", snapshot.data[index].Date.toString()),
                            _buildRow("From:", snapshot.data[index].From.toString()),
                            _buildRow("To:", snapshot.data[index].To.toString()),
                            _buildRow("Amount:", snapshot.data[index].amount.toString()),
                            _buildRow("Status:", snapshot.data[index].status.toString()),
                            Row(children: [
                              ElevatedButton(
                                // Register button
                                child: Text('Report',
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
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String did =snapshot.data[index].did.toString();
                                  prefs.setString("did", did);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => reportdriver()));
                                },
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                // Register button
                                child: Text('Rating&Review',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Button text color black
                                  ),),
                                style: ElevatedButton.styleFrom(
                                  // primary: Color(0xFFFF4A17), // Button background #FF4A17
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Color(0xFFFF4A17)),

                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                ),
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String did =snapshot.data[index].did.toString();
                                  prefs.setString("did", did);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => send_rating()));
                                },
                              ),
                            ],)


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
  final String drivername;

  final String email;
  final String Date;
  final String From;
  final String To;
  final String amount;
  final String status;
  final String did;




  Joke(this.id,this.drivername, this.email,this.Date,this.From,this.To,this.amount,this.status,this.did);
//  print("hiiiii");
}

