import 'package:ayeautoo/payment.dart';
import 'package:ayeautoo/user_Home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'chat_user.dart';

void main() {
  runApp(userviewrequestatus());
}

class userviewrequestatus extends StatelessWidget {
  const userviewrequestatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userviewrequeststatussub(),
    );
  }
}

class userviewrequeststatussub extends StatefulWidget {
  const userviewrequeststatussub({Key? key}) : super(key: key);

  @override
  State<userviewrequeststatussub> createState() => _userviewrequeststatussubState();
}

class _userviewrequeststatussubState extends State<userviewrequeststatussub> {
  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lid = prefs.getString("lid").toString();
    String url = prefs.getString("url").toString();
    String amount = prefs.getString("url").toString();
    String foodimage = "";
    var data = await http.post(Uri.parse(url.toString() + "/user_viewrequeststatus"),
        body: {"lid": lid});

    var jsonData = json.decode(data.body);
    List<Joke> jokes = [];
    for (var joke in jsonData["message"]) {
      Joke newJoke = Joke(
          joke["id"].toString(),
          joke["drivername"],
          joke["email"].toString(),
          joke["Date"].toString(),
          joke["From"].toString(),
          joke["To"].toString(),
          joke["amount"].toString(),
          joke["Status"].toString(),
          joke["did"].toString());

      jokes.add(newJoke);
    }
    return jokes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => userhome()));
          },
          icon: new Icon(Icons.arrow_back,color:Color(0xFFFF4A17) ,),
        ),
        title: Text('Request Status', style: TextStyle(color: Color(0xFFFF4A17))),
        backgroundColor: Colors.black,
        elevation: 6,
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getJokes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                  // only allow chat/pay once driver has approved the request
                  String status = snapshot.data[index].Status.toString().toLowerCase();
                  bool isApproved = status != "pending" && status != "rejected";

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),

                        side: BorderSide(color: Color(0xFFFF4A17)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            _buildRow("id:", snapshot.data[index].id.toString()),
                            _buildRow("Driver Name:", snapshot.data[index].drivername.toString()),
                            _buildRow("Email:", snapshot.data[index].email.toString()),
                            _buildRow("Date&Time:", snapshot.data[index].Date.toString()),
                            _buildRow("From:", snapshot.data[index].From.toString()),
                            _buildRow("To:", snapshot.data[index].To.toString()),
                            _buildRow("Amount:", snapshot.data[index].amount.toString()),
                            _buildRow("Status:", snapshot.data[index].Status.toString()),

                            if (!isApproved)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  "Chat and payment will be available once the driver approves your request.",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                            if (isApproved)
                              Row(
                                children: [
                                  ElevatedButton(
                                    child: Text('Chat',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, // Button text color black
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      side: BorderSide(color: Color(0xFFFF4A17)),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      String uid = snapshot.data[index].did.toString();
                                      prefs.setString("did", uid);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => chatuser()));
                                    },
                                  ),
                                  SizedBox(width: 20,),
                                  if (status != "paid")
                                    ElevatedButton(
                                      child: Text('Pay',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black, // Button text color black
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(color: Color(0xFFFF4A17)),

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                      ),
                                      onPressed: () async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        String uid = snapshot.data[index].id.toString();
                                        String amount = snapshot.data[index].amount.toString();

                                        prefs.setString("rid", uid);
                                        prefs.setString("amount", amount); // Ensure 'amount' is converted properly
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RazorpayPayment()),
                                        );
                                      },
                                    ),
                                ],
                              )
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
  final String Status;
  final String did;

  Joke(this.id, this.drivername, this.email, this.Date, this.From, this.To, this.amount, this.Status, this.did);
}