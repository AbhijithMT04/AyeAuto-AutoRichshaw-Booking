import 'dart:convert';
import 'package:ayeautoo/driver_Home.dart';
import 'package:ayeautoo/profilee_update.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(const ViewProfile());
}

class ViewProfile extends StatelessWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF7FF),
          elevation: 0,
        ),
      ),
      home: const ViewProfileState(),
    );
  }
}

class ViewProfileState extends StatefulWidget {
  const ViewProfileState({Key? key}) : super(key: key);

  @override
  State<ViewProfileState> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfileState> {
  late Future<Map<String, String>> profileFuture;

  final Color primaryColor = const Color(0xFFFF4A17);

  String getFileUrl(String baseUrl, String path) {
    if (path.isEmpty) return "";

    if (path.startsWith("http://") ||
        path.startsWith("https://")) {
      return path;
    }

    if (path.startsWith("/")) {
      return "$baseUrl$path";
    }

    return "$baseUrl/$path";
  }

  Future<Map<String, String>> _getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? lid = prefs.getString("lid");
    String? url = prefs.getString("url");

    if (lid == null || url == null) {
      throw Exception("Error fetching profile information.");
    }

    var response = await http.post(
      Uri.parse("$url/view_profile"),
      body: {
        "lid": lid,
      },
    );

    print("PROFILE RESPONSE: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Profile API failed");
    }

    var data = json.decode(response.body);

    String image = data['image']?.toString() ?? "";
    String proof = data['proof']?.toString() ?? "";

    String photoUrl = getFileUrl(url, image);
    String proofUrl = getFileUrl(url, proof);

    print("PHOTO URL: $photoUrl");
    print("PROOF URL: $proofUrl");

    return {
      "name": data['name']?.toString() ?? "Not available",
      "phone": data['phone']?.toString() ?? "Not available",
      "pin": data['pin']?.toString() ?? "Not available",
      "post": data['post']?.toString() ?? "Not available",
      "place": data['place']?.toString() ?? "Not available",
      "email": data['email']?.toString() ?? "Not available",
      "photo": photoUrl,
      "proof": proofUrl,
    };
  }

  @override
  void initState() {
    super.initState();
    profileFuture = _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7FF),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => driverhome(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFF4A17),
            size: 30,
          ),
        ),

        title: const Text(
          "Profile",
          style: TextStyle(
            color: Color(0xFFFF4A17),
            fontSize: 27,
            fontWeight: FontWeight.w400,
          ),
        ),

        centerTitle: true,
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------
      body: FutureBuilder<Map<String, String>>(
        future: profileFuture,

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF4A17),
              ),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFFF4A17),
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          // No data
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No profile data available.",
              ),
            );
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                40,
                35,
                40,
                110,
              ),

              child: Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: const Color(0xFFF9F2FA),

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(
                    color: const Color(0xFFFF9000),
                    width: 1.3,
                  ),

                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x559E6B5A),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 9),
                    ),
                  ],
                ),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    28,
                    18,
                    25,
                  ),

                  child: Column(
                    children: [

                      // --------------------------------------------------
                      // PROFILE IMAGE
                      // --------------------------------------------------
                      _buildProfileImage(
                        profile['photo']!,
                      ),

                      const SizedBox(height: 38),

                      // --------------------------------------------------
                      // PROFILE DETAILS
                      // --------------------------------------------------
                      _buildInfoRow(
                        "Name",
                        profile['name']!,
                      ),

                      _buildInfoRow(
                        "Email",
                        profile['email']!,
                      ),

                      _buildInfoRow(
                        "Phone",
                        profile['phone']!,
                      ),

                      _buildInfoRow(
                        "Place",
                        profile['place']!,
                      ),

                      _buildInfoRow(
                        "Post",
                        profile['post']!,
                      ),

                      _buildInfoRow(
                        "Pin",
                        profile['pin']!,
                      ),

                      _buildFileRow(
                        "License File",
                        profile['proof']!,
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

      // --------------------------------------------------
      // EDIT BUTTON
      // --------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfile(),
            ),
          );
        },

        backgroundColor: const Color(0xFFFF4A17),

        elevation: 8,

        shape: const CircleBorder(),

        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  // ======================================================
  // PROFILE IMAGE
  // ======================================================

  Widget _buildProfileImage(String photoUrl) {
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

                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
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

          width: 130,
          height: 150,

          fit: BoxFit.cover,

          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return const Icon(
              Icons.account_circle,
              size: 120,
              color: Colors.grey,
            );
          },
        )
            : const Icon(
          Icons.account_circle,
          size: 120,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFileRow(String label, String fileUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Expanded(
            flex: 6,
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    color: Color(0xFFFF4A17),
                    size: 25,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "View License",
                    style: TextStyle(
                      color: Color(0xFFFF4A17),
                      fontSize: 17,
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

  // ======================================================
  // PROFILE INFORMATION ROW
  // ======================================================

  Widget _buildInfoRow(
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 11,
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          // LABEL
          Expanded(
            flex: 4,

            child: Text(
              label,

              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // VALUE
          Expanded(
            flex: 6,

            child: Text(
              value,

              textAlign: TextAlign.right,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LicenseViewer extends StatefulWidget {
  final String fileUrl;

  const LicenseViewer({
    Key? key,
    required this.fileUrl,
  }) : super(key: key);

  @override
  State<LicenseViewer> createState() => _LicenseViewerState();
}

class _LicenseViewerState extends State<LicenseViewer> {

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      Future.delayed(Duration.zero, () {
        launchUrl(
          Uri.parse(widget.fileUrl),
          webOnlyWindowName: '_blank',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (kIsWeb) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF4A17),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7FF),
        title: const Text(
          "Driving License",
          style: TextStyle(
            color: Color(0xFFFF4A17),
          ),
        ),
      ),
      body: SfPdfViewer.network(
        widget.fileUrl,
      ),
    );
  }
}