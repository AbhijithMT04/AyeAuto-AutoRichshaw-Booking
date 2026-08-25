import 'package:ayeautoo/fromandto_loaction.dart';
import 'package:ayeautoo/user_Home.dart';
import 'package:ayeautoo/user_view_ratingandreview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main(){
  runApp(userviewavailabilitydrivers());
}

class userviewavailabilitydrivers extends StatelessWidget {
  const userviewavailabilitydrivers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userviewavailabilitydriverssub(),
    );
  }
}

class userviewavailabilitydriverssub extends StatefulWidget {
  const userviewavailabilitydriverssub({Key? key}) : super(key: key);

  @override
  State<userviewavailabilitydriverssub> createState() => _userviewavailabilitydriverssubState();
}

class _userviewavailabilitydriverssubState extends State<userviewavailabilitydriverssub> {
  String baseUrl = "";

  String getFileUrl(String path) {
    if (path.isEmpty) return "";

    if (path.startsWith("http://") || path.startsWith("https://")) {
      return path;
    }

    if (path.startsWith("/")) {
      return "$baseUrl$path";
    }

    return "$baseUrl/$path";
  }

  Future<List<Joke>> _getJokes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lid = prefs.getString("lid").toString();
    String url = prefs.getString("url").toString();
    baseUrl = url;

    var data =
    await http.post(Uri.parse(url.toString()+"/user_viewavailabledrivers"),
        body: {"lid":lid}
    );

    var jsonData = json.decode(data.body);
//    print(jsonData);
    List<Joke> jokes = [];
    for (var joke in jsonData["message"]) {
      print(joke);
      Joke newJoke = Joke(
        joke["id"].toString(),
        joke["Name"].toString(),
        joke["Phone"],
        joke["Email"].toString(),
        joke["Place"].toString(),
        joke["Pin"].toString(),
        joke["Post"].toString(),
        joke["Proof"].toString(),
        joke["Photo"].toString(),
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
        }, icon: new Icon(Icons.arrow_back, color: Color(0xFFFF4A17),)),
        title: Text('Available drivers',
            style: TextStyle(color: Color(0xFFFF4A17))),
        backgroundColor: Color(0xFFFFF7FF),
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
                  String photoUrl = getFileUrl(snapshot.data[index].Photo.toString());
                  String proofUrl = getFileUrl(snapshot.data[index].Proof.toString());

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

                            // --------------------------------------------------
                            // DRIVER PHOTO
                            // --------------------------------------------------
                            Center(
                              child: _buildDriverImage(photoUrl),
                            ),

                            SizedBox(height: 14),
                            _buildRow("id:", snapshot.data[index].id.toString()),
                            _buildRow("Driver Name:", snapshot.data[index].Name.toString()),
                            _buildRow("Phone:", snapshot.data[index].Phone.toString()),
                            _buildRow("Email:", snapshot.data[index].Email.toString()),
                            _buildRow("Place:", snapshot.data[index].Place.toString()),
                            _buildRow("Pin:", snapshot.data[index].Pin.toString()),
                            _buildRow("Post:", snapshot.data[index].Post.toString()),

                            // --------------------------------------------------
                            // PROOF / LICENSE FILE
                            // --------------------------------------------------
                            _buildFileRow("Proof:", proofUrl),

                            SizedBox(height: 10),

                            Row(children: [
                              ElevatedButton(
                                // Register button
                                child: Text('REVIEW'),
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String did = snapshot.data[index].id.toString();
                                  prefs.setString("did",did);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => userviewratingandreview()));
                                },
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                // Register button
                                child: Text('BOOK'),
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String did = snapshot.data[index].id.toString();
                                  prefs.setString("did",did);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => fromtolocation()));
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

  // ======================================================
  // DRIVER PHOTO (tap to view full screen, like profile page)
  // ======================================================
  Widget _buildDriverImage(String photoUrl) {
    return GestureDetector(
      onTap: () {
        if (photoUrl.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.account_circle,
                        size: 150,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      },
      child: ClipOval(
        child: photoUrl.isNotEmpty
            ? Image.network(
          photoUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.grey,
            );
          },
        )
            : const Icon(
          Icons.account_circle,
          size: 100,
          color: Colors.grey,
        ),
      ),
    );
  }

  // ======================================================
  // PROOF FILE ROW (tap to open, like profile page)
  // ======================================================
  Widget _buildFileRow(String label, String fileUrl) {
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
            child: GestureDetector(
              onTap: () async {
                if (fileUrl.isNotEmpty) {
                  final uri = Uri.parse(fileUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                }
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.picture_as_pdf,
                    color: Color(0xFFFF4A17),
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "View License",
                    style: TextStyle(
                      color: Color(0xFFFF4A17),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
  final String Name;
  final String Phone;

  final String Email;
  final String Place;
  final String Pin;
  final String Post;
  final String Proof;
  final String Photo;




  Joke(this.id,this.Name,this.Phone,this.Email, this.Place,this.Pin,this.Post,this.Proof,this.Photo);
//  print("hiiiii");
}