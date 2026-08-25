import 'package:ayeautoo/user_view_ratingandreview.dart';
import 'package:ayeautoo/user_Home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(userviewratingandreview());
}

class userviewratingandreview extends StatelessWidget {
  const userviewratingandreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: userviewratingandreviewsub()
    );
  }
}

class userviewratingandreviewsub extends StatefulWidget {
  const userviewratingandreviewsub({Key? key}) : super(key: key);

  @override
  State<userviewratingandreviewsub> createState() => _userviewratingandreviewsubState();
}

class _userviewratingandreviewsubState extends State<userviewratingandreviewsub> {
  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String did = prefs.getString("did").toString();
    String url = prefs.getString("url").toString();
    var data =
    await http.post(Uri.parse(url.toString()+"/user_viewratingandreview"),
        body: {"did":did}
    );

    var jsonData = json.decode(data.body);
//    print(jsonData);
    List<Joke> jokes = [];
    for (var joke in jsonData["message"]) {
      print(joke);
      Joke newJoke = Joke(
        joke["id"].toString(),
        joke["drivername"].toString(),
        joke["Rating"],
        joke["Review"].toString(),
        joke["Date"].toString(),
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
        }, icon: new Icon(Icons.arrow_back),),
        title: Text('Rating & Review', style: TextStyle(color: Color(0xFFFF4A17))),
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
                            _buildRow("Rating:", snapshot.data[index].Rating.toString()),
                            _buildRow("Review:", snapshot.data[index].Review.toString()),
                            _buildRow("Date:", snapshot.data[index].Date.toString()),

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
      //   floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(
      //           builder: (context)=>user_send_complaint(
      //           )));
      //     },
      //
      //   ),
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
  final String Rating;

  final String Review;
  final String Date;




  Joke(this.id,this.drivername,this.Rating, this.Review,this.Date);
//  print("hiiiii");
}
