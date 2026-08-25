import 'dart:io';
import 'dart:typed_data';
import 'package:ayeautoo/Login.dart';
import 'package:ayeautoo/driver_Home.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: driverregistartion()));
}

class driverregistartion extends StatefulWidget {
  @override
  _driverregistartionState createState() => _driverregistartionState();
}

class _driverregistartionState extends State<driverregistartion> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final place = TextEditingController();
  final pin = TextEditingController();
  final post = TextEditingController();
  final password = TextEditingController();
  final confirm_pass = TextEditingController();

  String? errormsg;
  bool? error = true, showprogress;
  bool passwordVisible = true;

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  String? _selectedImageExtension;

  Uint8List? _selectedLicenseBytes;
  String? _selectedLicenseName;
  String? _selectedLicenseExtension;

  // Handle File Picker Based on Platform
  void pickFileForPhoto() {
    if (kIsWeb) {
      startWebFilePickerForPhoto();
    } else {
      startMobileFilePickerForPhoto();
    }
  }

  // Web File Picker for Photo (Image)
  startWebFilePickerForPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _selectedImageBytes = file.bytes;
        _selectedImageName = file.name;
        _selectedImageExtension = file.extension;
      });
    } else {
      print("No file selected");
    }
  }

  // Mobile File Picker for Photo (Image)
  startMobileFilePickerForPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.bytes != null) {
        setState(() {
          _selectedImageBytes = file.bytes;
          _selectedImageName = file.name;
          _selectedImageExtension = file.extension;
        });
      } else if (file.path != null) {
        try {
          File localFile = File(file.path!);
          Uint8List fileData = await localFile.readAsBytes();
          setState(() {
            _selectedImageBytes = fileData;
            _selectedImageName = file.name;
            _selectedImageExtension = file.extension;
          });
        } catch (e) {
          print("Failed to read file content: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to read the selected file.")),
          );
        }
      }
    } else {
      print("No file selected");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No file selected")),
      );
    }
  }

  Future<void> pickLicenseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'jpg',
        'jpeg',
        'png',
      ],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      if (file.bytes != null) {
        setState(() {
          _selectedLicenseBytes = file.bytes;
          _selectedLicenseName = file.name;
          _selectedLicenseExtension = file.extension;
        });
      } else if (file.path != null) {
        try {
          File localFile = File(file.path!);

          Uint8List fileData = await localFile.readAsBytes();

          setState(() {
            _selectedLicenseBytes = fileData;
            _selectedLicenseName = file.name;
            _selectedLicenseExtension = file.extension;
          });
        } catch (e) {
          print("Failed to read license file: $e");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to read the selected license file."),
            ),
          );
        }
      }
    } else {
      print("No license file selected");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No license file selected"),
        ),
      );
    }
  }

  Future<void> _saveDetails(
      String name, String phone, String email, String place, String pin, String post, String password, String confirm_pass) async {
    if (_selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a profile photo."),
        ),
      );
      return;
    }

    if (_selectedLicenseBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select your license file."),
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String b = "1";
    String c = "1";
    String d = "1";
    var url = prefs.getString("url");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(url.toString() + "/and_driver_regiter"),
    );

    String mimeTypeForPhoto = _getMimeType(_selectedImageExtension ?? 'jpg');
    String filenameForPhoto = "file_${DateTime.now().millisecondsSinceEpoch}.${_selectedImageExtension ?? 'jpg'}";

    request.files.add(http.MultipartFile.fromBytes(
      'file1',
      _selectedImageBytes!,
      contentType: MediaType.parse(mimeTypeForPhoto),
      filename: filenameForPhoto,
    ));

    String mimeTypeForLicense =
    _getMimeType(_selectedLicenseExtension ?? 'pdf');

    String filenameForLicense =
        "license_${DateTime.now().millisecondsSinceEpoch}.${_selectedLicenseExtension ?? 'pdf'}";

    request.files.add(
      http.MultipartFile.fromBytes(
        'license_file',
        _selectedLicenseBytes!,
        contentType: MediaType.parse(mimeTypeForLicense),
        filename: filenameForLicense,
      ),
    );

    request.fields['aid'] = b;
    request.fields['lid'] = c;
    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['place'] = place;
    request.fields['pin'] = pin;
    request.fields['post'] = post;
    request.fields['password'] = password;
    request.fields['confirm_pass'] = confirm_pass;

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        showAlertDialog(context);
      } else {
        print("Failed to upload file: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';

      case 'png':
        return 'image/png';

      case 'pdf':
        return 'application/pdf';

      default:
        return 'application/octet-stream';
    }
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Driver Registered"),
      content: Text("Driver Register successfully."),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () { Navigator.push(
              context, MaterialPageRoute(builder: (context) => login()));
          }, icon: new Icon(Icons.arrow_back, color: Color(0xFFFF4A17)),),
          title: Text('Driver Registration', style: TextStyle(color: Color(0xFFFF4A17))),
          backgroundColor: Colors.black,
          elevation: 6,
          centerTitle: true,
        ),
        body: SingleChildScrollView(  // Adding scroll view
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    errorText: error == true ? "": "*",
                    labelText: "Name",
                    hintText: 'Enter Name',
                  ),
                ),
                TextField(
                  controller: phone,
                  decoration: InputDecoration(
                    errorText: error == true ? "": "*",
                    labelText: "Phone",
                    hintText: 'Enter Phone',
                  ),
                ),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    errorText: error == true ? "": "*",
                    labelText: "Email",
                    hintText: 'Enter Email',
                  ),
                ),
                TextField(
                  controller: place,
                  decoration: InputDecoration(
                    errorText: error == true ? "": "*",
                    labelText: "Place",
                    hintText: 'Enter Place',
                  ),
                ),
                TextField(
                  controller: pin,
                  decoration: InputDecoration(
                    errorText: error == true ? "": "*",
                    labelText: "Pin",
                    hintText: 'Enter Pin',
                  ),
                ),
                TextField(
                  controller: post,
                  decoration: InputDecoration(
                    errorText: error == true ? "": "*",
                    labelText: "Post",
                    hintText: 'Enter Post',
                  ),
                ),
                TextField(
                  controller: password,
                  decoration: InputDecoration(
                    errorText: error == true ? "": "*",
                    labelText: "Password",
                    hintText: 'Enter Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: passwordVisible,
                ),
                TextField(
                  controller: confirm_pass,
                  decoration: InputDecoration(
                    errorText: error == true ? "": "*",
                    labelText: "Confirm Password",
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: passwordVisible,
                ),

                // Choose Photo pickers here (you can customize the layout)
                ElevatedButton.icon(
                  onPressed: pickFileForPhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    _selectedImageName == null
                        ? "Pick Profile Photo"
                        : _selectedImageName!,
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: pickLicenseFile,
                  icon: const Icon(Icons.description),
                  label: Text(
                    _selectedLicenseName == null
                        ? "Pick License File"
                        : _selectedLicenseName!,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveDetails(
                      name.text,
                      phone.text,
                      email.text,
                      place.text,
                      pin.text,
                      post.text,
                      password.text,
                      confirm_pass.text,
                    );
                  },
                  child: Text("REGISTER"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
