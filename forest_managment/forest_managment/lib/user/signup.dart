import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forest_managment/login.dart';
import 'package:forest_managment/user/userhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';



void main() {
  runApp( signup(title: '',));
}

class signup extends StatefulWidget {
  const signup({super.key, required this.title});

  final String title;
  @override
  State<signup> createState() => _signupState();

}
class _signupState extends State<signup> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nametextController = TextEditingController();
  final TextEditingController _emailtextController = TextEditingController();
  final TextEditingController _numbertextController = TextEditingController();
  final TextEditingController _gendertextController = TextEditingController();
  final TextEditingController _placetextController = TextEditingController();
  final TextEditingController _districttextController = TextEditingController();
  final TextEditingController _statetextController = TextEditingController();
  final TextEditingController _pincodetextController = TextEditingController();
  final TextEditingController _passwordtextcontroller = TextEditingController();
  final TextEditingController _confirmpasswordtextController = TextEditingController();
  final TextEditingController _dobtextController = TextEditingController();

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
    String name = _nametextController.text;
    String email = _emailtextController.text;
    String number = _numbertextController.text;
    String gender = _gendertextController.text;
    String place = _placetextController.text;
    String district = _districttextController.text;
    String state = _statetextController.text;
    String pincode = _pincodetextController.text;
    String password = _passwordtextcontroller.text;
    String confirm_password = _confirmpasswordtextController.text;
    String dob = _dobtextController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    if (url == null) {
      Fluttertoast.showToast(msg: "Server URL not found.");
      return;
    }

    final uri = Uri.parse('$url/user_signup/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['number'] = number;
    request.fields['gender'] = gender;
    request.fields['place'] = place;
    request.fields['district'] = district;
    request.fields['state'] = state;
    request.fields['pincode'] = pincode;
    request.fields['password'] = password;
    request.fields['confirm_password'] = confirm_password;
    request.fields['dob'] = dob;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
    }

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Submitted successfully.");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>login(title: '',)));

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
          title: Text(widget.title),
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
                _selectedImage != null
                    ? Image.file(_selectedImage!, height: 150)
                    : const Text("No Image Selected"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _chooseImage,
                  child: const Text("Choose Image"),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nametextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailtextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _numbertextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _gendertextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Gender',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Gender is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _placetextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Place',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Place is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _districttextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your District',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'District is required';
                    }
                    return null;
                  },
                ), const SizedBox(height: 20),
                TextFormField(
                  controller: _statetextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your State',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'State is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _pincodetextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Pincode',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Pin is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordtextcontroller,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'password is required';
                    }
                    return null;
                  },
                ),const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmpasswordtextController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Your password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dobtextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Date Of Birth',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Date Of Birth is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _sendData();
                    } else {
                      Fluttertoast.showToast(msg: "Please fix errors in the form");
                    }
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
