import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forest_managment/login.dart';
import 'package:forest_managment/user/userhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';




void main() {
  runApp( change_password(title: '',));
}

class change_password extends StatefulWidget {
  const change_password({super.key, required this.title});

  final String title;
  @override
  State<change_password> createState() => _change_passwordState();

}
class _change_passwordState extends State<change_password> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentpasswordtextController = TextEditingController();
  final TextEditingController _changepasswordController = TextEditingController();
  final TextEditingController _confirmpasswordtextController = TextEditingController();

  File? _selectedImage;
  Future<void> _chooseImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
    else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  Future<void> _sendData() async {
    String currentpassword = _currentpasswordtextController.text;
    String changepassword = _changepasswordController.text;
    String confirmpassword = _confirmpasswordtextController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid')??'';

    if (url == null) {
      Fluttertoast.showToast(msg: "Server URL not found.");
      return;
    }

    final uri = Uri.parse('$url/changepassword_post/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['currentpassword'] = currentpassword;
    request.fields['lid'] = lid;
    request.fields['changepassword'] = changepassword;
    request.fields['confirmpassword'] = confirmpassword;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
    }

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Submitted successfully.");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>login(title: '')));
      } else {
        Fluttertoast.showToast(msg: "Submission failed.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const user_homepage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Change Password'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const SizedBox(height: 20),
                TextFormField(
                  controller: _currentpasswordtextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your current password',
                    border: OutlineInputBorder(),
                  ),

                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _changepasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your New Password',
                    border: OutlineInputBorder(),
                  ),

                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmpasswordtextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Confirm Password',
                    border: OutlineInputBorder(),
                  ),

                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {

                      _sendData();

                  },
                  child: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
