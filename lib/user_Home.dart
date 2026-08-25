import 'package:ayeautoo/Login.dart';
import 'package:ayeautoo/user_changepassword.dart';
import 'package:ayeautoo/user_profile.dart';
import 'package:ayeautoo/user_view_fare.dart';
import 'package:ayeautoo/user_view_availableDrivers.dart';
import 'package:ayeautoo/user_view_requeststatus.dart';
import 'package:ayeautoo/user_view_requesthistory.dart';
import 'package:ayeautoo/user_sendfeedback.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const userhome());
}

class userhome extends StatelessWidget {
  const userhome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const userhomesub(),
    );
  }
}

class userhomesub extends StatefulWidget {
  const userhomesub({Key? key}) : super(key: key);

  @override
  State<userhomesub> createState() => _userhomesubState();
}

class _userhomesubState extends State<userhomesub> {
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

      // GIF BACKGROUND
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

      // DRAWER
      drawer: buildDrawer(),
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
            // PROFILE
            ListTile(
              title: const Text("Profile"),
              leading: const Icon(
                Icons.supervised_user_circle,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => userprofile(),
                  ),
                );
              },
            ),

            // AVAILABLE DRIVERS
            ListTile(
              title: const Text("Available Drivers"),
              leading: const Icon(
                Icons.taxi_alert,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        userviewavailabilitydrivers(),
                  ),
                );
              },
            ),

            // FARE
            ListTile(
              title: const Text("Fare"),
              leading: const Icon(
                Icons.monetization_on_outlined,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => userviewfare(),
                  ),
                );
              },
            ),

            // REQUEST STATUS
            ListTile(
              title: const Text("Request Status"),
              leading: const Icon(
                Icons.add_alert,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        userviewrequestatus(),
                  ),
                );
              },
            ),

            // REQUEST HISTORY
            ListTile(
              title: const Text("Request History"),
              leading: const Icon(
                Icons.history,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        userviewrequesthistory(),
                  ),
                );
              },
            ),

            // SEND FEEDBACK
            ListTile(
              title: const Text("Send Feedback"),
              leading: const Icon(
                Icons.feedback_outlined,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        usersendfeedback(),
                  ),
                );
              },
            ),

            // CHANGE PASSWORD
            ListTile(
              title: const Text("Change Password"),
              leading: const Icon(
                Icons.password,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        userchangepassword(),
                  ),
                );
              },
            ),

            // LOGOUT
            ListTile(
              title: const Text("LogOut"),
              leading: const Icon(
                Icons.logout,
              ),
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