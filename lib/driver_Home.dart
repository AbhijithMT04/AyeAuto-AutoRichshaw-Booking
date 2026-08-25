import 'package:ayeautoo/Login.dart';
import 'package:ayeautoo/driver_changepassword.dart';
import 'package:ayeautoo/driver_paymenthistory.dart';
import 'package:ayeautoo/driver_sendfeedback.dart';
import 'package:ayeautoo/driver_view_requesthistory.dart';
import 'package:ayeautoo/driver_view_reviewandrating.dart';
import 'package:ayeautoo/rule.dart';
import 'package:ayeautoo/profilee_update.dart';
import 'package:ayeautoo/view_fare.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'driver_view_profileandupdate.dart';
import 'driver_view_requestandverify.dart';
import 'driver_view_verifiedrequest.dart';

void main() {
  runApp(const driverhome());
}

class driverhome extends StatelessWidget {
  const driverhome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const driverhomesub(),
    );
  }
}

class driverhomesub extends StatefulWidget {
  const driverhomesub({Key? key}) : super(key: key);

  @override
  State<driverhomesub> createState() => _driverhomesubState();
}

class _driverhomesubState extends State<driverhomesub> {
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  Future<void> getStatus() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isAvailable = prefs.getString("status") == "available";
    });
  }

  Future<void> setAvailability(bool available) async {
    final prefs = await SharedPreferences.getInstance();

    final url = prefs.getString("url");
    final lid = prefs.getString("lid");

    if (url == null || lid == null) return;

    try {
      final response = await http.post(
        Uri.parse(
          "$url/${available ? "set_as_available" : "set_as_not_available"}",
        ),
        body: {
          "lid": lid,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isAvailable = available;
        });

        await prefs.setString(
          "status",
          available ? "available" : "not available",
        );
      }
    } catch (e) {
      print("Status Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191719),

      appBar: AppBar(
        backgroundColor: const Color(0xFF191719),
        elevation: 0,
        toolbarHeight: 86,

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color(0xFFFF4A17),
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "AYE",
                style: TextStyle(
                  color: Color(0xFFFF6A00),
                  fontSize: 38,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: " AUTO",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        centerTitle: true,
      ),

      drawer: buildDrawer(),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/bag.gif",
              fit: BoxFit.cover,
            ),
          ),


        ],
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(0.55),

      child: ListTileTheme(
        textColor: Colors.black,
        iconColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewProfile(),
                  ),
                );
              },
            ),

            if (!isAvailable)
              ListTile(
                leading: const Icon(Icons.event_available),
                title: const Text("Set Availability"),
                onTap: () {
                  setAvailability(true);
                  Navigator.pop(context);
                },
              ),

            if (isAvailable)
              ListTile(
                leading: const Icon(Icons.event_busy),
                title: const Text("Set Not Available"),
                onTap: () {
                  setAvailability(false);
                  Navigator.pop(context);
                },
              ),

            ListTile(
              leading: const Icon(Icons.monetization_on_outlined),
              title: const Text("View Fare"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => driverviewfare(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.rule),
              title: const Text("Rules"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RulesApp(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.add_alert),
              title: const Text("View Request and Verify"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => driverviewrequestandverify(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.verified_outlined),
              title: const Text("Verified Requests"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => driverviewverifiedrequest(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Request History"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => driverviewrequesthistory(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.history_edu),
              title: const Text("Payment History"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => paymenthistory(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.star_half_outlined),
              title: const Text("Review & Rating"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => driverviewreviewandrating(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Send Feedback"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => sendfeedback(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.password),
              title: const Text("Change Password"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => changepassword(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => login(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}