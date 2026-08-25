import 'dart:convert';
import 'dart:io';

import 'package:ayeautoo/driver_view_profileandupdate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final Color primaryColor = const Color(0xFFFF4A17);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final placeController = TextEditingController();
  final postController = TextEditingController();
  final pinController = TextEditingController();

  String? lid;
  String? url;
  String? currentPhoto;
  String? currentProof;

  XFile? selectedPhoto;
  PlatformFile? selectedProof;

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      lid = prefs.getString("lid");
      url = prefs.getString("url");

      if (lid == null || url == null) {
        throw Exception("Login information not found");
      }

      final response = await http.post(
        Uri.parse("$url/view_profileandupdate"),
        body: {"lid": lid!},
      );

      print("PROFILE RESPONSE: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Server error ${response.statusCode}");
      }

      final data = json.decode(response.body);

      if (data["status"] != "ok") {
        throw Exception("Unable to load profile");
      }

      setState(() {
        nameController.text =
            (data["Name"] ?? data["name"] ?? "").toString();

        emailController.text =
            (data["Email"] ?? data["email"] ?? "").toString();

        phoneController.text =
            (data["Phone"] ?? data["phone"] ?? "").toString();

        placeController.text =
            (data["Place"] ?? data["place"] ?? "").toString();

        postController.text =
            (data["Post"] ?? data["post"] ?? "").toString();

        pinController.text =
            (data["Pin"] ?? data["pin"] ?? "").toString();

        final photo =
        (data["Photo"] ?? data["photo"] ?? data["image"] ?? "")
            .toString();

        final proof =
        (data["Proof"] ?? data["proof"] ?? "")
            .toString();

        currentPhoto =
        photo.isNotEmpty ? makeFileUrl(photo) : null;

        currentProof = proof.isNotEmpty
            ? (proof.startsWith("http") ? proof : "$url/$proof")
            : null;

        print("CURRENT PHOTO: $currentPhoto");
        print("CURRENT PROOF: $currentProof");

        isLoading = false;
      });
    } catch (e) {
      print("LOAD ERROR: $e");

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unable to load profile: $e"),
        ),
      );
    }
  }

  String makeFileUrl(String file) {
    if (file.startsWith("http://") || file.startsWith("https://")) {
      return file;
    }

    return "$url/${file.replaceFirst("/", "")}";
  }

  Future<void> selectPhoto() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedPhoto = image;
      });
    }
  }

  Future<void> selectLicense() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        selectedProof = result.files.single;
      });
    }
  }



  Future<void> updateProfile() async {
    if (lid == null || url == null) return;

    setState(() {
      isSaving = true;
    });

    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$url/and_edit_profile"),
      );

      request.fields.addAll({
        "lid": lid!,
        "name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "place": placeController.text,
        "post": postController.text,
        "pin": pinController.text,
      });

      if (selectedPhoto != null) {
        if (kIsWeb) {
          final bytes = await selectedPhoto!.readAsBytes();

          request.files.add(
            http.MultipartFile.fromBytes(
              "photo",
              bytes,
              filename: selectedPhoto!.name,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              "photo",
              selectedPhoto!.path,
            ),
          );
        }
      }

      if (selectedProof != null) {
        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              "proof",
              selectedProof!.bytes!,
              filename: selectedProof!.name,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              "proof",
              selectedProof!.path!,
            ),
          );
        }
      }

      final response = await request.send();
      final body = await response.stream.bytesToString();

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: $body");

      if (response.statusCode != 200) {
        throw Exception("Server error: ${response.statusCode}");
      }

      final data = json.decode(body);

      if (data["status"] != "ok") {
        throw Exception(data["message"] ?? "Update failed");
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ViewProfile(),
        ),
      );
    } catch (e) {
      print("UPDATE ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFF4A17),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          25,
          20,
          40,
        ),
        child: Column(
          children: [
            _buildProfilePhoto(),
            const SizedBox(height: 30),
            _buildTextField(nameController, "Name"),
            _buildTextField(
              emailController,
              "Email",
              TextInputType.emailAddress,
            ),
            _buildTextField(
              phoneController,
              "Phone",
              TextInputType.phone,
            ),
            _buildTextField(placeController, "Place"),
            _buildTextField(postController, "Post"),
            _buildTextField(
              pinController,
              "Pin",
              TextInputType.number,
            ),
            const SizedBox(height: 10),
            _buildLicensePicker(),
            const SizedBox(height: 35),
            SizedBox(
              width: 210,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipOval(
          child: Container(
            width: 145,
            height: 145,
            color: const Color(0xFFE9DDFB),
            child: selectedPhoto != null
                ? (kIsWeb
                ? Image.network(
              selectedPhoto!.path,
              fit: BoxFit.cover,
            )
                : Image.file(
              File(selectedPhoto!.path),
              fit: BoxFit.cover,
            ))
                : currentPhoto != null
                ? Image.network(
              currentPhoto!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.account_circle,
                  size: 145,
                  color: Colors.grey,
                );
              },
            )
                : const Icon(
              Icons.account_circle,
              size: 145,
              color: Colors.grey,
            ),
          ),
        ),
        GestureDetector(
          onTap: selectPhoto,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint, [
        TextInputType keyboardType = TextInputType.text,
      ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFFFF0EB),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(
              color: Colors.black54,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(
              color: Colors.black54,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLicensePicker() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EB),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.black54),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "License File",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          if (currentProof != null && selectedProof == null)
            Row(
              children: [
                const Icon(
                  Icons.picture_as_pdf,
                  color: Color(0xFFFF4A17),
                  size: 30,
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    "Current license file",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LicenseViewer(
                          fileUrl: currentProof!,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "View",
                    style: TextStyle(
                      color: Color(0xFFFF4A17),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

          if (selectedProof != null)
            Row(
              children: [
                const Icon(
                  Icons.picture_as_pdf,
                  color: Color(0xFFFF4A17),
                  size: 30,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    selectedProof!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 8),

          OutlinedButton.icon(
            onPressed: selectLicense,
            icon: const Icon(
              Icons.upload_file,
              color: Color(0xFFFF4A17),
            ),
            label: const Text(
              "Change License File",
              style: TextStyle(
                color: Color(0xFFFF4A17),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFFFF4A17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    placeController.dispose();
    postController.dispose();
    pinController.dispose();
    super.dispose();
  }
}