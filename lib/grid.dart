import 'package:ayeautoo/Login.dart';
import 'package:ayeautoo/driver_changepassword.dart';
import 'package:ayeautoo/driver_sendfeedback.dart';
import 'package:ayeautoo/driver_view_requesthistory.dart';
import 'package:ayeautoo/driver_view_reviewandrating.dart';
import 'package:ayeautoo/profilee_update.dart';
import 'package:ayeautoo/user_Home.dart';
import 'package:ayeautoo/view_fare.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'driver_view_profileandupdate.dart';
import 'driver_view_requestandverify.dart';
import 'driver_view_verifiedrequest.dart';
import 'package:http/http.dart' as http;

import 'grid.dart';

void main() {
  runApp(drv());
}

class drv extends StatelessWidget {
  const drv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: driverhomesub(),
    );
  }
}

class driverhomesub extends StatefulWidget {
  const driverhomesub({Key? key}) : super(key: key);

  @override
  State<driverhomesub> createState() => _driverhomesubState();
}

class _driverhomesubState extends State<driverhomesub> {
  String status = "not available"; // Default value

  // Function to fetch status from SharedPreferences
  Future<void> _getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      status = prefs.getString("status") ?? "not available";
    });
  }

  @override
  void initState() {
    super.initState();
    _getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AYE AUTO", style: TextStyle(color: Color(0xFFFF4A17))),
        backgroundColor: Colors.black, // AppBar background black
        elevation: 6,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Adjust number of items per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 10, // Number of items in the grid
        itemBuilder: (context, index) {
          List<Map<String, dynamic>> gridItems = [
            // {"icon": Icons.supervised_user_circle, "title": "Profile", "route":/ profile_update()},
            {"icon": Icons.grid_view, "title": "Grid", "route": GeeksForGeeks()},
            {"icon": Icons.event_available, "title": "Set Availability", "route": null},
            {"icon": Icons.event_busy, "title": "Set Not Available", "route": null},
            {"icon": Icons.monetization_on_outlined, "title": "View Fare", "route": driverviewfare()},
            {"icon": Icons.add_alert, "title": "View Request & Verify", "route": driverviewrequestandverify()},
            {"icon": Icons.verified_outlined, "title": "Verified Requests", "route": driverviewverifiedrequest()},
            {"icon": Icons.history, "title": "Request History", "route": driverviewrequesthistory()},
            {"icon": Icons.star_half_outlined, "title": "Review & Rating", "route": driverviewreviewandrating()},
          ];

          return GestureDetector(
            onTap: () {
              if (gridItems[index]["route"] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => gridItems[index]["route"]),
                );
              } else if (gridItems[index]["title"] == "Set Availability" && status == "not available") {
                // Handle Set Availability
                _setAvailability();
              } else if (gridItems[index]["title"] == "Set Not Available" && status == "available") {
                // Handle Set Not Available
                _setNotAvailable();
              }
            },
            child: Card(
              color: Colors.black,
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(gridItems[index]["icon"], color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(gridItems[index]["title"], style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: Text("Profile"),
              leading: Icon(Icons.supervised_user_circle),
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => view_driver_profile()));
              // },
            ),
            // ListTile(
            //   title: Text("Grid"),
            //   leading: Icon(Icons.grid_view),
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => GeeksForGeeks()));
            //   },
            // ),
            if (status == "not available")
              ListTile(
                title: Text("Set Availability"),
                leading: Icon(Icons.event_available),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  var url = prefs.getString("url");
                  String? lid = prefs.getString("lid");
                  try {
                    var data = await http.post(
                      Uri.parse(url.toString() + "/set_as_available"),
                      body: {"lid": lid},
                    );
                    if (data.statusCode == 200) {
                      setState(() {
                        status = "available";
                      });
                    } else {
                      // Handle error
                    }
                  } catch (e) {
                    // Handle network or other errors
                  }
                },
              ),
            if (status == "available")
              ListTile(
                title: Text("Set Not Available"),
                leading: Icon(Icons.event_busy),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  var url = prefs.getString("url");
                  String? lid = prefs.getString("lid");
                  try {
                    var data = await http.post(
                      Uri.parse(url.toString() + "/set_as_not_available"),
                      body: {"lid": lid},
                    );
                    if (data.statusCode == 200) {
                      setState(() {
                        status = "not available"; // Update the status to not available after setting
                      });
                    } else {
                      // Handle error
                    }
                  } catch (e) {
                    // Handle network or other errors
                  }
                },
              ),
            ListTile(
              title: Text("View Fare"),
              leading: Icon(Icons.monetization_on_outlined),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => driverviewfare()));
              },
            ),
            ListTile(
              title: Text("View Request and Verify"),
              leading: Icon(Icons.add_alert),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => driverviewrequestandverify()));
              },
            ),
            ListTile(
              title: Text("Verified Requests"),
              leading: Icon(Icons.verified_outlined),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => driverviewverifiedrequest()));
              },
            ),
            ListTile(
              title: Text("Request History"),
              leading: Icon(Icons.history),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => driverviewrequesthistory()));
              },
            ),
            ListTile(
              title: Text("Payment History"),
              leading: Icon(Icons.history_edu),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>login()));
              },
            ),
            ListTile(
              title: Text("Review & Rating"),
              leading: Icon(Icons.star_half_outlined),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => driverviewreviewandrating()));
              },
            ),
            ListTile(
              title: Text("Send Feedback"),
              leading: Icon(Icons.feedback),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => sendfeedback()));
              },
            ),
            ListTile(
              title: Text("Change Password"),
              leading: Icon(Icons.password),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => changepassword()));
              },
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setAvailability() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = prefs.getString("url");
    String? lid = prefs.getString("lid");
    try {
      var data = await http.post(
        Uri.parse(url.toString() + "/set_as_available"),
        body: {"lid": lid},
      );
      if (data.statusCode == 200) {
        setState(() {
          status = "available";
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _setNotAvailable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = prefs.getString("url");
    String? lid = prefs.getString("lid");
    try {
      var data = await http.post(
        Uri.parse(url.toString() + "/set_as_not_available"),
        body: {"lid": lid},
      );
      if (data.statusCode == 200) {
        setState(() {
          status = "not available";
        });
      }
    } catch (e) {
      // Handle error
    }
  }
}

class GeeksForGeeks {
}
