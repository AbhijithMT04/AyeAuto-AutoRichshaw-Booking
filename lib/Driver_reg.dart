// import 'dart:io'; // Required for mobile file operations
// import 'dart:typed_data'; // For handling file bytes
// import 'package:arbookingg/Login.dart';
// import 'package:flutter/foundation.dart'; // For platform checks (kIsWeb)
// import 'package:file_picker/file_picker.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// //
// void main() {
//   runApp(MaterialApp(home: driverregistartion()));
// }
//
// class driverregistartion extends StatefulWidget {
//   @override
//   _driverregistartionState createState() => _driverregistartionState();
// }
//
// class _driverregistartionState extends State<driverregistartion> {
//   final name = TextEditingController();
//   final phone = TextEditingController();
//   final email = TextEditingController();
//   final place = TextEditingController();
//   final pin = TextEditingController();
//   final post = TextEditingController();
//   final photo = TextEditingController();
//   final proof = TextEditingController();
//   final password = TextEditingController();
//   final confirm_pass = TextEditingController();
//
//   Uint8List? _selectedFileBytes;
//   String? _selectedFileName;
//   String? _selectedFileExtension;
//
//   Uint8List? _selectedFileBytes1;
//   String? _selectedFileNam1;
//   String? _selectedFileExtension1;
//
//   /// Handle File Picker for PDF
//   void pickPdf() {
//     if (kIsWeb) {
//       startWebFilePickerPdf();
//     } else {
//       startMobileFilePickerPdf();
//     }
//   }
//
//   /// Handle File Picker for JPG (Photo)
//   void pickJpg() {
//     if (kIsWeb) {
//       startWebFilePickerJpg();
//     } else {
//       startMobileFilePickerJpg();
//     }
//   }
//
//   /// Web File Picker for PDF
//   startWebFilePickerPdf() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//
//     if (result != null) {
//       PlatformFile file = result.files.first;
//       setState(() {
//         _selectedFileBytes = file.bytes;
//         _selectedFileName = file.name;
//         _selectedFileExtension = file.extension;
//       });
//     } else {
//       print("No file selected");
//     }
//   }
//
//   /// Mobile File Picker for PDF
//   startMobileFilePickerPdf() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//
//     if (result != null) {
//       PlatformFile file = result.files.first;
//       if (file.bytes != null) {
//         setState(() {
//           _selectedFileBytes = file.bytes;
//           _selectedFileName = file.name;
//           _selectedFileExtension = file.extension;
//         });
//       } else if (file.path != null) {
//         try {
//           File localFile = File(file.path!);
//           Uint8List fileData = await localFile.readAsBytes();
//           setState(() {
//             _selectedFileBytes = fileData;
//             _selectedFileName = file.name;
//             _selectedFileExtension = file.extension;
//           });
//         } catch (e) {
//           print("Failed to read file content: $e");
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Failed to read the selected file.")),
//           );
//         }
//       }
//     } else {
//       print("No file selected");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("No file selected")),
//       );
//     }
//   }
//
//   /// Web File Picker for JPG (Photo)
//   startWebFilePickerJpg() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'jpeg'],
//     );
//
//     if (result != null) {
//       PlatformFile file = result.files.first;
//       setState(() {
//         _selectedFileBytes1 = file.bytes;
//         _selectedFileNam1 = file.name;
//         _selectedFileExtension1 = file.extension;
//       });
//     } else {
//       print("No file selected");
//     }
//   }
//
//   /// Mobile File Picker for JPG (Photo)
//   startMobileFilePickerJpg() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'jpeg'],
//     );
//
//     if (result != null) {
//       PlatformFile file = result.files.first;
//       if (file.bytes != null) {
//         setState(() {
//           _selectedFileBytes1 = file.bytes;
//           _selectedFileNam1 = file.name;
//           _selectedFileExtension1 = file.extension;
//         });
//       } else if (file.path != null) {
//         try {
//           File localFile = File(file.path!);
//           Uint8List fileData = await localFile.readAsBytes();
//           setState(() {
//             _selectedFileBytes1 = fileData;
//             _selectedFileNam1 = file.name;
//             _selectedFileExtension1 = file.extension;
//           });
//         } catch (e) {
//           print("Failed to read file content: $e");
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Failed to read the selected file.")),
//           );
//         }
//       }
//     } else {
//       print("No file selected");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("No file selected")),
//       );
//     }
//   }
//
//   /// Send File to Django Backend
//   Future<void> _saveDetails(String name, String phone, String email, String place, String pin, String post, String password, String confirm_pass) async {
//     if (_selectedFileBytes == null || _selectedFileName == null || _selectedFileBytes1 == null || _selectedFileNam1 == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select both files before uploading.")),
//       );
//       return;
//     }
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String b = "1";
//     String c = "1";
//     String d = "1";
//     var url = prefs.getString("url");
//
//     var request = http.MultipartRequest(
//       "POST",
//       Uri.parse(url.toString() + "/and_regiter"),
//     );
//
//     // PDF File
//     String mimeTypePdf = _getMimeType(_selectedFileExtension ?? 'pdf');
//     String filenamePdf = "file_${DateTime.now().millisecondsSinceEpoch}.${_selectedFileExtension ?? 'pdf'}";
//     request.files.add(http.MultipartFile.fromBytes(
//       'file',
//       _selectedFileBytes!,
//       contentType: MediaType.parse(mimeTypePdf),
//       filename: filenamePdf,
//     ));
//
//     // JPG File (Photo)
//     String mimeTypeJpg = _getMimeType(_selectedFileExtension1 ?? 'jpg');
//     String filenameJpg = "file1_${DateTime.now().millisecondsSinceEpoch}.${_selectedFileExtension1 ?? 'jpg'}";
//     request.files.add(http.MultipartFile.fromBytes(
//       'file1',
//       _selectedFileBytes1!,
//       contentType: MediaType.parse(mimeTypeJpg),
//       filename: filenameJpg,
//     ));
//
//     request.fields['aid'] = b;
//     request.fields['lid'] = c;
//     request.fields['name'] = name;
//     request.fields['phone'] = phone;
//     request.fields['email'] = email;
//     request.fields['place'] = place;
//     request.fields['pin'] = pin;
//     request.fields['post'] = post;
//     request.fields['password'] = password;
//     request.fields['confirm_pass'] = confirm_pass;
//
//     try {
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         showAlertDialog(context);
//       } else {
//         print("Failed to upload file: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   String _getMimeType(String extension) {
//     switch (extension.toLowerCase()) {
//       case 'pdf':
//         return 'application/pdf';
//       case 'jpg':
//       case 'jpeg':
//         return 'image/jpeg';
//       default:
//         return 'application/octet-stream';
//     }
//   }
//
//   /// Success Alert Dialog
//   showAlertDialog(BuildContext context) {
//     Widget okButton = TextButton(
//       child: Text("OK"),
//       onPressed: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
//       },
//     );
//     AlertDialog alert = AlertDialog(
//       title: Text("Driver Registered"),
//       content: Text("Files uploaded successfully."),
//       actions: [
//         okButton,
//       ],
//     );
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Driver Registration', style: TextStyle(color: Color(0xFFFF4A17))),
//           backgroundColor: Colors.black,
//           elevation: 6,
//           centerTitle: true,
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               TextField(controller: name, decoration: InputDecoration(labelText: "Name", hintText: 'Enter Your Name')),
//               TextField(controller: phone, decoration: InputDecoration(labelText: "Phone", hintText: 'Enter Your phone number')),
//               TextField(controller: email, decoration: InputDecoration(labelText: "Email", hintText: 'Enter Your email')),
//               TextField(controller: place, decoration: InputDecoration(labelText: "Place", hintText: 'Enter Your place')),
//               TextField(controller: pin, decoration: InputDecoration(labelText: "Pin", hintText: 'Enter Your pin')),
//               TextField(controller: post, decoration: InputDecoration(labelText: "Post", hintText: 'Enter Your post')),
//               TextField(controller: password, decoration: InputDecoration(labelText: "Password", hintText: 'Enter Your password')),
//               TextField(controller: confirm_pass, decoration: InputDecoration(labelText: "Confirm Password", hintText: 'Confirm Your password')),
//
//               SizedBox(height: 20),
//               SizedBox(
//                 width: 150,
//                 height: 40,
//                 child: ElevatedButton.icon(
//                   onPressed: pickJpg,
//                   icon: Icon(Icons.image),
//                   label: Text("Select Photo"),
//                 ),
//               ),
//               SizedBox(height: 20),
//               SizedBox(
//                 width: 150,
//                 height: 40,
//                 child: ElevatedButton.icon(
//                   onPressed: pickPdf,
//                   icon: Icon(Icons.picture_as_pdf),
//                   label: Text("Select License"),
//                 ),
//               ),
//               SizedBox(height: 20),
//               SizedBox(
//                 width: 150,
//                 height: 40,
//                 child: ElevatedButton(
//                   onPressed: () => _saveDetails(
//                     name.text,
//                     phone.text,
//                     email.text,
//                     place.text,
//                     pin.text,
//                     post.text,
//                     password.text,
//                     confirm_pass.text,
//                   ),
//                   child: Text("Upload"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
